import os
from contextlib import closing
from decimal import Decimal

import vertica_python
from fastapi import FastAPI, HTTPException, Path
from pydantic import BaseModel


app = FastAPI(
    title="BI Subscriber API",
    version="1.0.0"
)


# API response structure
class SubscriberResponse(BaseModel):
    msisdn: str
    rvn_amt: Decimal | None
    total_voice_mou: Decimal | None
    total_sms_count: int | None
    total_data_usg: Decimal | None
    segment: str | None
    next_best_offer: str | None


# Connect to the Vertica database
def get_connection():
    return vertica_python.connect(
        host=os.getenv("VERTICA_HOST", "localhost"),
        port=int(os.getenv("VERTICA_PORT", "5433")),
        user=os.getenv("VERTICA_USER", "dbadmin"),
        password=os.getenv("VERTICA_PASSWORD", ""),
        database=os.getenv("VERTICA_DATABASE", "BI"),
        connection_timeout=10,
        read_timeout=30,
    )


# Check whether the API is running
@app.get("/health")
def health():
    return {"status": "up"}


# Retrieve subscriber information using MSISDN
@app.get(
    "/subscriber/{msisdn}",
    response_model=SubscriberResponse
)
def get_subscriber(
    msisdn: str = Path(
        ...,
        pattern=r"^[0-9]{7,15}$",
        description="Subscriber MSISDN"
    )
):
    sql = """
        SELECT
            CAST(msisdn AS VARCHAR) AS msisdn,
            rvn_amt,
            total_voice_mou,
            total_sms_count,
            total_data_usg,
            segment,
            next_best_offer
        FROM bi.subscriber_summary
        WHERE msisdn = %s
        LIMIT 1
    """

    try:
        with closing(get_connection()) as connection:
            cursor = connection.cursor()

            # Parameterized query protects against SQL injection
            cursor.execute(sql, [msisdn])

            row = cursor.fetchone()

    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail="BI database is unavailable"
        ) from exc

    if row is None:
        raise HTTPException(
            status_code=404,
            detail="MSISDN not found"
        )

    return SubscriberResponse(
        msisdn=row[0],
        rvn_amt=row[1],
        total_voice_mou=row[2],
        total_sms_count=row[3],
        total_data_usg=row[4],
        segment=row[5],
        next_best_offer=row[6],
    )