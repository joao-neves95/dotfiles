try {
  csharprepl.exe
}
catch {
  dotnet tool install -g csharprepl
  csharprepl.exe
}
