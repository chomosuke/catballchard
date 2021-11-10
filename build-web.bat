CD frontend
CALL flutter build web
CD ..
RD /S /Q "web_build"
MD "web_build"
COPY "frontend\build\web" "web_build"
