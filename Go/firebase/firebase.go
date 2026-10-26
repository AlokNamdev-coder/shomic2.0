package firebase

import (
	"context"

	firebase "firebase.google.com/go/v4"

	"google.golang.org/api/option"
)

var App *firebase.App

func InitFirebase(){
	option := option.WithAuthCredentialsFile(option.ServiceAccount,"Shomic.json")

	app,err := firebase.NewApp(context.Background(),nil,option)

	if err!=nil{
		panic(err)
	}

	App=app

}