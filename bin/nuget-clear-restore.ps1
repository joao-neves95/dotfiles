dotnet nuget locals all --clear
# git clean -xfd

$baseFolder = Get-Location
git rm \**\bin -f -r
#rmdir $(-join($baseFolder, "\**\bin")) -Force -r
git rm "\**\obj" -f -r
#rmdir $(-join($baseFolder, "\**\obj")) -Force -r
git rm "\**\packages.lock.json"
#rm $(-join($baseFolder, "\**\packages.lock.json")) -Force
