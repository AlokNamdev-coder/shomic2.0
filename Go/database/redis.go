package database

import (
	"context"
	"fmt"

	"github.com/redis/go-redis/v9"
)

var Redis *redis.Client

func ConnectRedis() {
	Redis = redis.NewClient(&redis.Options{
		Addr: "localhost:6379",
		Password: "",
		DB: 0,
	})

	err:=Redis.Ping(context.Background()).Err()

	if err!=nil{
		panic(err)
	}

	fmt.Println("Successfullly Started the Redis")


}

func CloseRedis(){
	if Redis !=nil{
		err:=Redis.Close()

		if err!=nil{
			fmt.Println("Error Occured While Closing the Redis")
		}

		fmt.Println("Redis Connection Stopped Successfully")
	}


}

