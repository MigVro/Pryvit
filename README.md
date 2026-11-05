# Pryvit

Learn Ukrainian with flashcards: add a word, and a background worker fetches its translation and generates the audio.

## Run locally

    dotnet run --project src/Pryvit.Api
    cd client && npm install && npm run dev

The API health check is at `http://localhost:5123/health`.
