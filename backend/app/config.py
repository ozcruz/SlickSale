"""Application configuration, read entirely from environment variables."""

from __future__ import annotations

from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Backend settings. No secrets in code — everything comes from the env."""

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    openai_api_key: str
    # Base URL of the deployed Modal service; used for both /synthesize and /transcribe.
    modal_tts_url: str
    # Comma-separated list of allowed CORS origins (the Flutter web app).
    allowed_origins: str = "http://localhost:8080"

    @property
    def allowed_origins_list(self) -> list[str]:
        return [origin.strip() for origin in self.allowed_origins.split(",") if origin.strip()]

    @property
    def modal_base_url(self) -> str:
        """Modal URL without a trailing slash, so we can append paths cleanly."""
        return self.modal_tts_url.rstrip("/")


@lru_cache
def get_settings() -> Settings:
    """Cached settings singleton."""
    return Settings()
