dotnet nuget locals all --clear
#git clean -xfd
git rm **/bin -f -r
git rm **/obj -f -r
git rm **/packages.lock.json -f
dotnet restore %1.sln
pause
