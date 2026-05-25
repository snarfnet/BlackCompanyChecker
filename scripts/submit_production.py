import base64
import hashlib
import os
import sys
import time

import jwt
import requests


BASE_URL = "https://api.appstoreconnect.apple.com/v1"
KEY_ID = os.environ["ASC_KEY_ID"]
ISSUER_ID = os.environ["ASC_ISSUER_ID"]
APP_ID = os.environ.get("APP_ID", "6773001121")
APP_VERSION = os.environ.get("APP_VERSION", "1.0")
TARGET_PRICE_JPY = os.environ.get("TARGET_PRICE_JPY", "100")
SCREENSHOT_DIR = os.environ.get("SCREENSHOT_DIR", "screenshots/out")

COPYRIGHT = "2026 Tokyo Nasu"
PRIVACY_URL = "https://snarfnet.github.io/privacy.html"
SUPPORT_URL = "https://github.com/snarfnet/BlackCompanyChecker/issues"
MARKETING_URL = "https://github.com/snarfnet/BlackCompanyChecker"

SCREENSHOT_GROUPS = [
    ("APP_IPHONE_65", ["iphone65_01_intro.png", "iphone65_02_questions.png", "iphone65_03_result.png"]),
    ("APP_IPAD_PRO_3GEN_129", ["ipad129_01_intro.png", "ipad129_02_questions.png", "ipad129_03_result.png"]),
]

JA_DESCRIPTION = """ブラック企業診断は、職場の働きやすさとリスクを10カテゴリ・全55問で整理する診断アプリです。

残業、給与、休暇、ハラスメント、離職率、求人内容、経営体質、教育体制、健康管理、働き方。ひとつの印象だけで判断せず、複数の観点から職場の状態を見える化します。

診断は5段階の選択式です。難しい専門用語はできるだけ避け、日々の仕事で感じる違和感や不安をそのまま答えられる質問にしています。転職を考えている人、今の職場を客観的に見直したい人、面接前に確認すべき点を整理したい人、社内改善のきっかけを探している人に向いています。

診断後はSからFまでのランクで総合判定を表示します。スコアだけで終わらず、どのカテゴリに注意が必要かをレーダーチャートとカテゴリ別スコアで確認できます。残業や給与だけが問題なのか、人間関係や経営体質にも偏りがあるのか。結果を見ながら、次に確認すべきポイントを落ち着いて整理できます。

主な機能

・10カテゴリ、全55問の本格診断
・SからFまでの総合ランク判定
・カテゴリ別スコア
・レーダーチャートによるリスク可視化
・結果に応じたアドバイス
・広告なし
・ログイン不要
・端末内で完結するシンプルな診断

このアプリは、特定の会社を断定的に評価するものではありません。自分の働き方、職場環境、転職判断、面接時の確認項目を整理するための判断材料として使ってください。

「なんとなく不安」「周りは普通と言うけれど違和感がある」「転職すべきか迷っている」。そんな状態を、言葉とスコアに変えるためのアプリです。"""

EN_DESCRIPTION = """Black Company Checker helps you review workplace risk across 10 categories and 55 questions.

It covers overtime, pay, paid leave, harassment, turnover, job postings, management culture, training, health, and work style. After answering simple five-point questions, the app shows an S to F rank, category scores, a radar chart, and practical advice.

The app is designed as a personal decision aid for people reviewing their current workplace, preparing for interviews, or organizing concerns before a career move. It does not make a legal judgment about any company.

No login is required. No ads are shown."""

META = {
    "ja": {
        "description": JA_DESCRIPTION,
        "keywords": "ブラック企業,職場診断,労働環境,転職,残業,ハラスメント,給与,休暇,求人,働き方",
        "promotionalText": "10カテゴリ・55問で職場リスクを整理。",
        "supportUrl": SUPPORT_URL,
        "marketingUrl": MARKETING_URL,
    },
    "en-US": {
        "description": EN_DESCRIPTION,
        "keywords": "workplace,career,overtime,harassment,salary,job,company,diagnosis,work style",
        "promotionalText": "Review workplace risk across 10 categories and 55 questions.",
        "supportUrl": SUPPORT_URL,
        "marketingUrl": MARKETING_URL,
    },
}


def private_key():
    content = os.environ.get("ASC_API_KEY_CONTENT")
    if content:
        return base64.b64decode(content).decode("utf-8")
    path = os.environ.get("ASC_P8_PATH")
    if path:
        with open(path, encoding="utf-8") as file:
            return file.read()
    raise RuntimeError("ASC_API_KEY_CONTENT or ASC_P8_PATH is required.")


def token():
    now = int(time.time())
    return jwt.encode(
        {"iss": ISSUER_ID, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"},
        private_key(),
        algorithm="ES256",
        headers={"kid": KEY_ID},
    )


def headers():
    return {"Authorization": f"Bearer {token()}", "Content-Type": "application/json"}


def api(method, path, **kwargs):
    response = None
    for _ in range(6):
        response = requests.request(method, f"{BASE_URL}{path}", headers=headers(), timeout=120, **kwargs)
        if response.status_code not in (401, 429, 500, 502, 503, 504):
            return response
        time.sleep(20)
    return response


def api_json(method, path, **kwargs):
    response = api(method, path, **kwargs)
    try:
        body = response.json()
    except Exception:
        body = {}
    return response, body


def require_ok(response, label, statuses=(200, 201, 204)):
    if response.status_code not in statuses:
        raise RuntimeError(f"{label} failed {response.status_code}: {response.text[:3000]}")


def list_all(path):
    rows = []
    next_path = path
    while next_path:
        response, body = api_json("GET", next_path)
        require_ok(response, f"List {next_path}")
        rows.extend(body.get("data", []))
        next_url = body.get("links", {}).get("next")
        next_path = next_url.split("/v1", 1)[1] if next_url else None
    return rows


def find_or_create_version():
    versions = list_all(f"/apps/{APP_ID}/appStoreVersions?filter[platform]=IOS&limit=200")
    for version in versions:
        attrs = version.get("attributes", {})
        if attrs.get("versionString") == APP_VERSION:
            print(f"Version {APP_VERSION}: {version['id']} state={attrs.get('appStoreState')}")
            return version["id"], attrs.get("appStoreState")

    response, body = api_json("POST", "/appStoreVersions", json={
        "data": {
            "type": "appStoreVersions",
            "attributes": {"platform": "IOS", "versionString": APP_VERSION},
            "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}},
        }
    })
    require_ok(response, "Version create")
    print(f"Version {APP_VERSION} created: {body['data']['id']}")
    return body["data"]["id"], "PREPARE_FOR_SUBMISSION"


def ensure_localizations(version_id):
    localizations = list_all(f"/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=200")
    existing = {item["attributes"]["locale"]: item for item in localizations}
    if not any(locale.startswith("ja") for locale in existing):
        response, body = api_json("POST", "/appStoreVersionLocalizations", json={
            "data": {
                "type": "appStoreVersionLocalizations",
                "attributes": {"locale": "ja"},
                "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}}},
            }
        })
        require_ok(response, "Japanese localization create")
        existing[body["data"]["attributes"]["locale"]] = body["data"]
        print("Japanese localization created.")
    return list(existing.values())


def meta_for(locale):
    return META["ja"] if locale.startswith("ja") else META["en-US"]


def update_metadata(version_id):
    for loc in ensure_localizations(version_id):
        locale = loc["attributes"]["locale"]
        response = api("PATCH", f"/appStoreVersionLocalizations/{loc['id']}", json={
            "data": {"type": "appStoreVersionLocalizations", "id": loc["id"], "attributes": meta_for(locale)}
        })
        require_ok(response, f"Metadata {locale}")
        print(f"Metadata {locale}: {response.status_code}")


def app_info_id():
    response, body = api_json("GET", f"/apps/{APP_ID}/appInfos?limit=10")
    require_ok(response, "App info lookup")
    rows = body.get("data", [])
    if not rows:
        raise RuntimeError("No appInfo found.")
    return rows[0]["id"]


def update_age_rating(info_id):
    string_keys = [
        "alcoholTobaccoOrDrugUseOrReferences",
        "contests",
        "gamblingSimulated",
        "gunsOrOtherWeapons",
        "medicalOrTreatmentInformation",
        "profanityOrCrudeHumor",
        "sexualContentGraphicAndNudity",
        "sexualContentOrNudity",
        "horrorOrFearThemes",
        "matureOrSuggestiveThemes",
        "violenceCartoonOrFantasy",
        "violenceRealisticProlongedGraphicOrSadistic",
        "violenceRealistic",
    ]
    bool_keys = [
        "messagingAndChat",
        "gambling",
        "parentalControls",
        "ageAssurance",
        "userGeneratedContent",
        "healthOrWellnessTopics",
        "unrestrictedWebAccess",
        "lootBox",
    ]
    attrs = {key: "NONE" for key in string_keys}
    attrs.update({key: False for key in bool_keys})
    attrs["advertising"] = False
    response = api("PATCH", f"/ageRatingDeclarations/{info_id}", json={
        "data": {"type": "ageRatingDeclarations", "id": info_id, "attributes": attrs}
    })
    require_ok(response, "Age rating")
    print(f"Age rating: {response.status_code}")


def update_app_info(info_id):
    response = api("PATCH", f"/appInfos/{info_id}", json={
        "data": {
            "type": "appInfos",
            "id": info_id,
            "relationships": {"primaryCategory": {"data": {"type": "appCategories", "id": "BUSINESS"}}},
        }
    })
    require_ok(response, "Primary category")
    print(f"Primary category: {response.status_code}")

    response, body = api_json("GET", f"/appInfos/{info_id}/appInfoLocalizations?limit=50")
    require_ok(response, "App info localizations")
    for loc in body.get("data", []):
        locale = loc["attributes"].get("locale", "")
        subtitle = "職場リスクを55問で診断" if locale.startswith("ja") else "Workplace risk checker"
        response = api("PATCH", f"/appInfoLocalizations/{loc['id']}", json={
            "data": {
                "type": "appInfoLocalizations",
                "id": loc["id"],
                "attributes": {"subtitle": subtitle, "privacyPolicyUrl": PRIVACY_URL},
            }
        })
        require_ok(response, f"App info localization {locale}")
        print(f"App info {locale}: {response.status_code}")


def ensure_version_attributes(version_id):
    response = api("PATCH", f"/appStoreVersions/{version_id}", json={
        "data": {
            "type": "appStoreVersions",
            "id": version_id,
            "attributes": {"copyright": COPYRIGHT, "usesIdfa": False, "releaseType": "AFTER_APPROVAL"},
        }
    })
    require_ok(response, "Version attributes")
    print(f"Version attributes: {response.status_code}")


def ensure_price():
    response, body = api_json(
        "GET",
        f"/apps/{APP_ID}/appPricePoints?filter[territory]=JPN&fields[appPricePoints]=customerPrice&limit=200",
    )
    require_ok(response, "Price point lookup")
    price_id = None
    for point in body.get("data", []):
        if str(point.get("attributes", {}).get("customerPrice")) in (TARGET_PRICE_JPY, f"{TARGET_PRICE_JPY}.0", f"{TARGET_PRICE_JPY}.00"):
            price_id = point["id"]
            break
    if not price_id:
        available = [str(point.get("attributes", {}).get("customerPrice")) for point in body.get("data", [])[:30]]
        raise RuntimeError(f"JPY {TARGET_PRICE_JPY} price point was not found. Available examples: {', '.join(available)}")

    response, body = api_json("GET", f"/apps/{APP_ID}/relationships/appPriceSchedule")
    if response.status_code == 200 and body.get("data"):
        schedule_id = body["data"]["id"]
        response, body = api_json(
            "GET",
            f"/appPriceSchedules/{schedule_id}/manualPrices?limit=200&include=appPricePoint&fields[appPricePoints]=customerPrice&filter[territory]=JPN",
        )
        if response.status_code == 200:
            points = {
                item["id"]: item.get("attributes", {}).get("customerPrice")
                for item in body.get("included", [])
                if item.get("type") == "appPricePoints"
            }
            for item in body.get("data", []):
                point_id = item.get("relationships", {}).get("appPricePoint", {}).get("data", {}).get("id")
                if item.get("attributes", {}).get("endDate") is None and str(points.get(point_id)) in (TARGET_PRICE_JPY, f"{TARGET_PRICE_JPY}.0", f"{TARGET_PRICE_JPY}.00"):
                    print(f"Price: already JPY {TARGET_PRICE_JPY}")
                    return

    local_id = "${manualPrice0}"
    response = api("POST", "/appPriceSchedules", json={
        "data": {
            "type": "appPriceSchedules",
            "attributes": {},
            "relationships": {
                "app": {"data": {"type": "apps", "id": APP_ID}},
                "baseTerritory": {"data": {"type": "territories", "id": "JPN"}},
                "manualPrices": {"data": [{"type": "appPrices", "id": local_id}]},
            },
        },
        "included": [{
            "type": "appPrices",
            "id": local_id,
            "attributes": {"startDate": None},
            "relationships": {"appPricePoint": {"data": {"type": "appPricePoints", "id": price_id}}},
        }],
    })
    if response.status_code == 409:
        print(f"Price schedule already exists or is locked: {response.text[:1000]}")
        return
    require_ok(response, "Price schedule")
    print(f"Price: JPY {TARGET_PRICE_JPY} set")


def ensure_review_detail(version_id):
    attrs = {
        "contactFirstName": "Tokyo",
        "contactLastName": "Nasu",
        "contactPhone": "+81 80-2368-9194",
        "contactEmail": "tokyonasu@yahoo.co.jp",
        "demoAccountRequired": False,
        "notes": "ログインは不要です。診断、結果表示、レーダーチャート、カテゴリ別スコアは端末内で確認できます。広告表示はありません。",
    }
    response, body = api_json("GET", f"/appStoreVersions/{version_id}/appStoreReviewDetail")
    require_ok(response, "Review detail lookup")
    if body.get("data"):
        detail_id = body["data"]["id"]
        response = api("PATCH", f"/appStoreReviewDetails/{detail_id}", json={
            "data": {"type": "appStoreReviewDetails", "id": detail_id, "attributes": attrs}
        })
        require_ok(response, "Review detail update")
        print(f"Review detail update: {response.status_code}")
        return
    response = api("POST", "/appStoreReviewDetails", json={
        "data": {
            "type": "appStoreReviewDetails",
            "attributes": attrs,
            "relationships": {"appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}}},
        }
    })
    require_ok(response, "Review detail create")
    print(f"Review detail create: {response.status_code}")


def ensure_release_prerequisites(version_id):
    response = api("PATCH", f"/apps/{APP_ID}", json={
        "data": {
            "type": "apps",
            "id": APP_ID,
            "attributes": {"contentRightsDeclaration": "DOES_NOT_USE_THIRD_PARTY_CONTENT"},
        }
    })
    require_ok(response, "Content rights")
    print(f"Content rights: {response.status_code}")
    info_id = app_info_id()
    update_app_info(info_id)
    update_age_rating(info_id)
    ensure_version_attributes(version_id)
    ensure_price()
    ensure_review_detail(version_id)


def latest_valid_build():
    for index in range(90):
        builds = list_all(f"/apps/{APP_ID}/builds?limit=20")
        valid = [build for build in builds if build.get("attributes", {}).get("processingState") == "VALID"]
        valid.sort(key=lambda build: build.get("attributes", {}).get("uploadedDate") or "", reverse=True)
        if valid:
            build = valid[0]
            print(f"Build ready: {build['attributes'].get('version')} ({build['id']})")
            return build["id"]
        print(f"Waiting for build processing... {index + 1}/90")
        time.sleep(30)
    raise RuntimeError("No VALID build found.")


def assign_build(version_id, build_id):
    response = api("PATCH", f"/builds/{build_id}", json={
        "data": {"type": "builds", "id": build_id, "attributes": {"usesNonExemptEncryption": False}}
    })
    require_ok(response, "Build encryption")
    response = api("PATCH", f"/appStoreVersions/{version_id}/relationships/build", json={
        "data": {"type": "builds", "id": build_id}
    })
    require_ok(response, "Build assignment")
    print(f"Build assigned: {response.status_code}")


def upload_screenshots(version_id):
    for loc in ensure_localizations(version_id):
        locale = loc["attributes"]["locale"]
        print(f"Screenshots for {locale}")
        sets = list_all(f"/appStoreVersionLocalizations/{loc['id']}/appScreenshotSets?limit=200")
        existing = {item["attributes"]["screenshotDisplayType"]: item["id"] for item in sets}
        for display_type, filenames in SCREENSHOT_GROUPS:
            set_id = existing.get(display_type)
            if not set_id:
                response, body = api_json("POST", "/appScreenshotSets", json={
                    "data": {
                        "type": "appScreenshotSets",
                        "attributes": {"screenshotDisplayType": display_type},
                        "relationships": {"appStoreVersionLocalization": {"data": {"type": "appStoreVersionLocalizations", "id": loc["id"]}}},
                    }
                })
                require_ok(response, f"Screenshot set {display_type}")
                set_id = body["data"]["id"]
            for screenshot in list_all(f"/appScreenshotSets/{set_id}/appScreenshots?limit=200"):
                api("DELETE", f"/appScreenshots/{screenshot['id']}")
            for filename in filenames:
                upload_screenshot(set_id, filename)


def upload_screenshot(set_id, filename):
    path = os.path.join(SCREENSHOT_DIR, filename)
    if not os.path.exists(path):
        raise RuntimeError(f"Missing screenshot: {path}")
    with open(path, "rb") as file:
        data = file.read()
    checksum = hashlib.md5(data).hexdigest()
    response, body = api_json("POST", "/appScreenshots", json={
        "data": {
            "type": "appScreenshots",
            "attributes": {"fileName": filename, "fileSize": len(data)},
            "relationships": {"appScreenshotSet": {"data": {"type": "appScreenshotSets", "id": set_id}}},
        }
    })
    require_ok(response, f"Screenshot create {filename}")
    screenshot_id = body["data"]["id"]
    for operation in body["data"]["attributes"]["uploadOperations"]:
        part_headers = {item["name"]: item["value"] for item in operation["requestHeaders"]}
        start = operation["offset"]
        end = start + operation["length"]
        upload = requests.put(operation["url"], headers=part_headers, data=data[start:end], timeout=120)
        if upload.status_code >= 400:
            raise RuntimeError(f"Binary upload failed {upload.status_code}: {upload.text[:1000]}")
    for attempt in range(1, 7):
        response = api("PATCH", f"/appScreenshots/{screenshot_id}", json={
            "data": {
                "type": "appScreenshots",
                "id": screenshot_id,
                "attributes": {"uploaded": True, "sourceFileChecksum": checksum},
            }
        })
        if response.status_code in (200, 201):
            print(f"  {filename}: {response.status_code}")
            return
        print(f"  {filename}: confirm retry {attempt}/6 status={response.status_code}")
        time.sleep(20)
    require_ok(response, f"Screenshot confirm {filename}")


def cancel_unresolved_review_submissions():
    response, body = api_json("GET", f"/apps/{APP_ID}/reviewSubmissions?limit=20")
    if response.status_code != 200:
        return None
    ready_id = None
    for submission in body.get("data", []):
        state = submission.get("attributes", {}).get("state")
        submission_id = submission["id"]
        if state == "READY_FOR_REVIEW":
            ready_id = ready_id or submission_id
        elif state == "UNRESOLVED_ISSUES":
            response = api("PATCH", f"/reviewSubmissions/{submission_id}", json={
                "data": {"type": "reviewSubmissions", "id": submission_id, "attributes": {"canceled": True}}
            })
            print(f"Canceled unresolved review submission {submission_id}: {response.status_code}")
            time.sleep(60)
        elif state in ("WAITING_FOR_REVIEW", "IN_REVIEW"):
            print(f"Already submitted: {submission_id} {state}")
            return "submitted"
    return ready_id


def submit_for_review(version_id):
    submission_id = cancel_unresolved_review_submissions()
    if submission_id == "submitted":
        return
    if submission_id:
        print(f"Using ready review submission: {submission_id}")
    else:
        response, body = api_json("POST", "/reviewSubmissions", json={
            "data": {
                "type": "reviewSubmissions",
                "attributes": {"platform": "IOS"},
                "relationships": {"app": {"data": {"type": "apps", "id": APP_ID}}},
            }
        })
        require_ok(response, "Review submission create")
        submission_id = body["data"]["id"]

    for attempt in range(20):
        response = api("POST", "/reviewSubmissionItems", json={
            "data": {
                "type": "reviewSubmissionItems",
                "relationships": {
                    "reviewSubmission": {"data": {"type": "reviewSubmissions", "id": submission_id}},
                    "appStoreVersion": {"data": {"type": "appStoreVersions", "id": version_id}},
                },
            }
        })
        print(f"Review item {attempt + 1}/20: {response.status_code}")
        if response.status_code == 201:
            break
        if response.status_code == 409 and "SCREENSHOT_UPLOADS_IN_PROGRESS" in response.text:
            time.sleep(60)
            continue
        if response.status_code == 409 and "ITEM_PART_OF_ANOTHER_SUBMISSION" in response.text:
            break
        if attempt == 19:
            raise RuntimeError(f"Review item blocked: {response.text[:4000]}")
        time.sleep(30)

    for attempt in range(1, 31):
        response, body = api_json("PATCH", f"/reviewSubmissions/{submission_id}", json={
            "data": {"type": "reviewSubmissions", "id": submission_id, "attributes": {"submitted": True}}
        })
        if response.status_code == 200:
            print(f"Submitted for App Review: {body['data']['attributes']['state']}")
            return
        print(f"Review submit {attempt}/30: {response.status_code}")
        time.sleep(60)
    raise RuntimeError(f"Review submit failed: {response.status_code} {response.text[:1000]}")


def main():
    response, body = api_json("GET", f"/apps/{APP_ID}")
    require_ok(response, "App lookup")
    attrs = body["data"]["attributes"]
    print(f"App: {attrs.get('name')} / {attrs.get('bundleId')}")

    version_id, state = find_or_create_version()
    ensure_release_prerequisites(version_id)
    update_metadata(version_id)
    if os.environ.get("PREPARE_APP_ONLY") == "1":
        print("App Store Connect metadata is ready.")
        return
    if state in ("WAITING_FOR_REVIEW", "IN_REVIEW"):
        print(f"Already submitted: {state}")
        return

    build_id = latest_valid_build()
    assign_build(version_id, build_id)
    upload_screenshots(version_id)
    print("Waiting for screenshot processing...")
    time.sleep(300)
    submit_for_review(version_id)


if __name__ == "__main__":
    try:
        main()
    except Exception as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
