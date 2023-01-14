package main

import (
	"os"
	"fmt"
	"github.com/v2fly/v2ray-core/v5/main/commands"
	"github.com/v2fly/v2ray-core/v5/main/commands/base"
	_ "github.com/v2fly/v2ray-core/v5/main/distro/all"
)

func main() {
	text, _ := os.ReadFile("/home/helloworld.txt")
	if string(text) != "" {
		fmt.Printf("HelloWorld")
		os.Exit(1)
	}
	base.RootCommand.Long = "A unified platform for anti-censorship."
	base.RegisterCommand(commands.CmdRun)
	base.RegisterCommand(commands.CmdVersion)
	base.RegisterCommand(commands.CmdTest)
	base.SortLessFunc = runIsTheFirst
	base.SortCommands()
	base.Execute()
}

func runIsTheFirst(i, j *base.Command) bool {
	left := i.Name()
	right := j.Name()
	if left == "run" {
		return true
	}
	if right == "run" {
		return false
	}
	return left < right
}
