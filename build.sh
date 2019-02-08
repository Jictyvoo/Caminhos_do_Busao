cd src
zip -r ../game.love ./*
cd ../
cat bin/love.exe game.love > bin/CaminhosDoBusao.exe

cd bin/
zip -r ../caminhos_do_busao.zip SDL2.dll OpenAL32.dll CaminhosDoBusao.exe license.txt love.dll lua51.dll mpg123.dll msvcp120.dll msvcr120.dll
