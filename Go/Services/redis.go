package services

import (
	"context"
	"encoding/json"
	"fmt"
	"shomic/database"
	"time"
)

var ctx = context.Background()

func SetCache(key string, value any,Time time.Duration) {

	data,error:=json.Marshal(value)

	if error!=nil{
		fmt.Println("Error in Marshalling the Data:",error)
		return 
	}

	result,err:=database.Redis.Set(ctx,key,data,Time).Result()

	if err!=nil{
		fmt.Println("Error Occured while Caching in Redis:",err)
	}

	fmt.Println(result)


}

func GetCache(key string,variable any){

	
	result,err:=database.Redis.Get(ctx,key).Result()

	if err!=nil{
		fmt.Println(err)
	}

	errr:=json.Unmarshal([]byte(result),variable)

	if errr!=nil{
		fmt.Println(errr)
		return 
	}


}

func CacheExist(key string) bool {
	res,err:=database.Redis.Exists(ctx,key).Result()

	if err!=nil{
		fmt.Println(err)
	}

	if res==1{
		return true
	}else{
		return false
	}
}

func DeleteCache(key string){
	res,err:=database.Redis.Del(ctx,key).Result()

	if err!=nil{
		fmt.Println("DeleteCache:",err)

	}

	fmt.Println("Successfully Deleted The Cache:",res)
}