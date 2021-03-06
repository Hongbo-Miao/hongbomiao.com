package utils

import (
	"context"
	"github.com/Hongbo-Miao/hongbomiao.com/api-go/api/proto/greet/v1"
	"github.com/rs/zerolog/log"
	"go.opencensus.io/plugin/ocgrpc"
	"google.golang.org/grpc"
)

type Greeting struct {
	Content string `json:"content"`
}

func GetGreeting(firstName string, lastName string) (greeting Greeting, err error) {
	req := &v1.GreetRequest{
		Greeting: &v1.Greeting{
			FirstName: firstName,
			LastName:  lastName,
		},
	}

	var config = GetConfig()
	cc, err := grpc.Dial(config.GRPCHost+":"+config.GRPCPort, grpc.WithInsecure(),
		grpc.WithStatsHandler(new(ocgrpc.ClientHandler)))
	if err != nil {
		log.Error().Err(err).Msg("grpc.Dial")
	}
	defer cc.Close()

	c := v1.NewGreetServiceClient(cc)
	res, err := c.Greet(context.Background(), req)
	return Greeting{
		Content: res.Result,
	}, err
}
