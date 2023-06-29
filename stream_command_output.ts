import { exec } from "child_process";

function streamCommand(command: string) {
  console.log(`Running ${command}`);
  const proc = exec(command);
  proc.stdout?.setEncoding("utf-8");
  proc.stderr?.setEncoding("utf-8");
  proc.stdout?.on("data", function (data) {
    console.log(data);
  });

  proc.stderr?.on("data", function (data) {
    console.log(data);
  });
}
