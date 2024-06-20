package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
)

type Data struct {
	Field1 string json:"field1"
	Field2 string json:"field2"
}

func jsonReader(filePath string) ([]Data, error) {
	file, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	var data []Data
	err = json.Unmarshal(file, &data)
	if err != nil {
		return nil, err
	}

	return data, nil
}

func main() {
	json1 := os.Getenv("JSON1")
	json2 := os.Getenv("JSON2")
	sortBy := os.Getenv("SORTBY")

	if json1 == "" {
		fmt.Println("JSON1 argument was not provided")
		return
	}
	if json2 == "" {
		fmt.Println("JSON2 argument is null")
		return
	}
	if sortBy == "" {
		fmt.Println("SORTBY argument was not provided")
		return
	}

	data1, err := jsonReader(json1)
	if err != nil {
		fmt.Println("Error reading JSON1:", err)
		return
	}

	data2, err := jsonReader(json2)
	if err != nil {
		fmt.Println("Error reading JSON2:", err)
		return
	}

	sort.Slice(data1, func(i, j int) bool {
		return data1[i].Field1 < data1[j].Field1
	})

	sort.Slice(data2, func(i, j int) bool {
		return data2[i].Field1 < data2[j].Field1
	})

	if len(data1) != len(data2) {
		fmt.Println("Array size validation failed")
		return
	}

	for i := 0; i < len(data1); i++ {
		if data1[i] != data2[i] {
			fmt.Printf("Element validation failed at index %d: %+v != %+v\n", i, data1[i], data2[i])
		}
	}
	fmt.Println("Validation passed")
}
