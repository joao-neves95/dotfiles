@ECHO OFF 

SET DEFAULT_MESSAGE=Update

IF [%1] == [] (
    SET MESSAGE=%DEFAULT_MESSAGE%
) ELSE (
    SET MESSAGE=%1
)

git add .
git commit -m%MESSAGE%
git push
