# قراردادهای وب‌سرویس، ساختار API و پاکت‌های تبادل داده
## REST API Specifications, JSON Contracts & Endpoints Catalog

این سند مشخصات قراردادهای تبادل داده در لایه وب‌سرویس، معماری آپلود مستقیم فایل (Pre-signed S3 URL)، صفحه‌بندی مکالمات، گزارش تخلف کاربران و پست‌ها، و سطوح دسترسی مهمان (Guest Read-Only) را تدوین می‌کند.

---

## ۱. ساختار استاندارد پاکت پاسخ، خطا و قوانین مهمان (Public Guest Rules)

### ۱. دسترسی مهمان در برابر کاربران واردشده (Public Guest Experience)
* **مشاهده آزاد (Free Read-Only):** کاربران مهمان (بدون احراز هویت) به کلیه فیدها، صفحات نمادها، پروفایل‌ها، و نتایج جستجو دسترسی کامل دارند (جهت بهینه‌سازی حداکثری SEO).
* **دیوار ورود (Login Wall Triggers):** انجام هرگونه تعامل شامل: پسندیدن (`Like`)، ثبت پاسخ (`Reply`)، ارسال توییت (`Post`)، بازنشر (`Repost`)، دنبال کردن (`Follow`)، نشان‌کردن (`Bookmark`) و **دانلود/مشاهده فایل‌های پیوست اسناد مالی** خطای `401 Unauthorized` برگردانده و پنجره مودال ورود پیامکی (Login Modal) را باز می‌کند.

### ۲. ساختار استاندارد پاکت پاسخ:
```json
{
  "success": true,
  "data": {},
  "meta": {
    "cursor": "eyJjcmVhdGVkX2F0IjoiMjAyNi0xMC0wOVQxMDo0MDowMFoifQ==",
    "has_more": true
  },
  "error": null
}
```

### ۳. ساختار استاندارد پاکت خطا:
```json
{
  "success": false,
  "data": null,
  "meta": null,
  "error": {
    "code": "AUTH_REQUIRED",
    "message": "جهت انجام این تعامل یا دانلود فایل، لطفاً وارد حساب کاربری خود شوید.",
    "field": null
  }
}
```

---

## ۲. مشخصات اندپوئینت‌های کلیدی سامانه

### الف) ماژول آپلود مستقیم رسانه و فایل‌ها (`/api/v1/media`) — معماری S3 Pre-signed URL

برای جلوگیری از درگیر شدن سرور بک‌اند با ترافیک آپلود فایل‌های سنگین ۱۰ مگابایتی، فرآیند بر اساس الگوی Pre-signed URL (Option A) پیاده‌سازی شده است:

```text
[ کلاینت ] ──( ۱. درخواست آپلود: نام و حجم و MIME )──► [ بک‌اند توییت‌تحلیل ]
                                                          │
                                                          ├─ اعتبارسنجی نوع فایل و حجم (زیر ۱۰MB)
                                                          ├─ تولید کلید یکتا و آدرس موقت معتبر (۱۵ دقیقه)
                                                          ▼
[ کلاینت ] ◄──( ۲. دریافت upload_url پیش‌امضا و file_url )─┘
    │
    └──( ۳. ارسال مستقیم بایت‌های فایل با متد PUT )──► [ باکت ابری S3 / MinIO ]
    │
    └──( ۴. ارسال file_url نهایی در بدنه POST /api/v1/posts )──► [ بک‌اند توییت‌تحلیل ]
```

#### ۱. دریافت آدرس پیش‌امضا برای آپلود فایل
* **مسیر:** `POST /api/v1/media/presigned-url`
* **هدر:** `Authorization: Bearer <TOKEN>`
* **بدنه درخواست:**
```json
{
  "file_name": "Foolad_Fundamental_Q3.pdf",
  "file_type": "application/pdf",
  "file_size_bytes": 4500000
}
```
* **پاسخ موفق (HTTP 200):**
```json
{
  "success": true,
  "data": {
    "upload_url": "https://s3.ir-thr-1.storage.twittahlil.ir/attachments/2026/10/uuid-foolad.pdf?X-Amz-Signature=...",
    "file_url": "https://storage.twittahlil.ir/attachments/2026/10/uuid-foolad.pdf",
    "key": "attachments/2026/10/uuid-foolad.pdf",
    "expires_in_seconds": 900
  }
}
```

#### ۲. دانلود امن اسناد و پیوست‌ها (مستلزم احراز هویت / Soft Login Trigger)
* **مسیر:** `GET /api/v1/media/download/:id`
* **هدر:** `Authorization: Bearer <TOKEN>` (برای مهمانان خطای ۴۰۱ صادر و Login Modal را فعال می‌کند)
* **عملکرد:** پس از اعتبارسنجی ورود کاربر، سیستم آدرس موقت امن ریدایرکت (HTTP 302 به Pre-signed Download URL با انقضای ۵ دقیقه) یا استریم امن فایل را تحویل می‌دهد.
* **پاسخ خطای مهمان (HTTP 401):**
```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "AUTH_REQUIRED",
    "message": "جهت دانلود فایل‌ها و اسناد تحلیلی، لطفاً وارد حساب کاربری خود شوید."
  }
}
```

---

### ب) ماژول انتشار توییت و دستیار هوش مصنوعی (`/api/v1/posts`)

#### ۱. بررسی دستیار نگارش هوش مصنوعی (مخصوص کاربران تاییدشده)
* **مسیر:** `POST /api/v1/posts/ai-assistant-check`
* **هدر:** `Authorization: Bearer <TOKEN>` (نشان آبی/طلایی/سبز الزامی)
* **بدنه درخواست:**
```json
{
  "content": "به نظر میرسد ایران خودرو به زودی از زیان انباشته خارج شود."
}
```
* **پاسخ موفق (HTTP 200):**
```json
{
  "success": true,
  "data": {
    "has_suggestions": true,
    "suggested_content": "به نظر می‌رسد $خودرو (ایران خودرو) به زودی از زیان انباشته خارج شود.",
    "suggested_symbols": ["خودرو"],
    "corrected_typos": true
  }
}
```

#### ۲. انتشار توییت جدید
* **مسیر:** `POST /api/v1/posts`
* **بدنه درخواست:**
```json
{
  "content": "شکست خط روند نزولی و تثبیت در محدوده حمایتی. $فولاد",
  "stock_ids": ["9f323c8a-78b1-419b-a320-b88301ec711a"],
  "attachments": [
    {
      "url": "https://storage.twittahlil.ir/attachments/2026/10/uuid-foolad.pdf",
      "file_type": "application/pdf",
      "file_name": "Foolad_Fundamental_Q3.pdf",
      "size_bytes": 4500000
    }
  ],
  "reply_to_id": null
}
```

#### ۳. دریافت مکالمات و پاسخ‌های تو در تو همراه با صفحه‌بندی (Comment Thread Pagination)
* **مسیر:** `GET /api/v1/posts/:id/replies?cursor=...&limit=20`
* **پاسخ موفق (HTTP 200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "e43b67c2-1111-4f9e-a89b-944a956d2994",
      "content": "آیا مقاومت ۵۴۰ تومانی را در محاسبات خود لحاظ کرده‌اید؟",
      "author": { "handle": "reza_trader", "display_name": "رضا محمدی" },
      "reply_to_id": "c1f7b820-22e3-4f9e-a89b-944a956d2994",
      "likes_count": 3,
      "created_at": "2026-10-09T11:00:00Z"
    }
  ],
  "meta": {
    "cursor": "eyJjcmVhdGVkX2F0IjoiMjAyNi0xMC0wOVQxMTowMDowMFoifQ==",
    "has_more": true
  }
}
```

---

### ج) ماژول فیدهای خانه، کاوش و هشتگ‌ها (`/api/v1/feeds`)

#### ۱. فید خانه با ۳ تب
* **مسیر:** `GET /api/v1/feeds/home?tab=for-you&cursor=...&limit=20`
* **پارامتر `tab`:** `for-you` (مخصوص شما) | `all` (همه) | `following` (دنبال‌شده).

#### ۲. فید بخش کاوش
* **مسیر:** `GET /api/v1/feeds/explore?sort=views&timeframe=24h&cursor=...&limit=20`
* **پارامتر `sort`:** `views` | `comments` | `likes`.
* **پارامتر `timeframe`:** `24h` | `48h` | `7d`.

#### ۳. فید اختصاصی هشتگ موضوعی (`/api/v1/feeds/hashtags/:tag`)
* **مسیر:** `GET /api/v1/feeds/hashtags/:tag?cursor=...&limit=20` (مثال: `/api/v1/feeds/hashtags/شاخص_کل`)
* **پاسخ:** فهرست توییت‌های عمومی حاوی هشتگ مذکور به ترتیب معکوس زمانی.

---

### د) ماژول نشان‌شده‌ها و گزارش تخلف (`/api/v1/bookmarks` و `/api/v1/reports`)

#### ۱. نشان‌کردن توییت (Toggle Bookmark)
* **مسیر:** `POST /api/v1/posts/:id/bookmark`
* **پاسخ:** `{ "success": true, "data": { "is_bookmarked": true } }`

#### ۲. دریافت توییت‌های نشان‌شده کاربر
* **مسیر:** `GET /api/v1/bookmarks?cursor=...&limit=20`

#### ۳. ثبت گزارش تخلف پست یا پروفایل کاربر (Reporting API)
* **مسیر:** `POST /api/v1/reports`
* **بدنه درخواست جهت گزارش پست:**
```json
{
  "target_type": "POST",
  "post_id": "4b54e7c3-3760-4927-b6f7-b82aa1dcba55",
  "reason": "SIGNAL_SELLING",
  "details": "تبلیغ کانال VIP تلگرام در متن توییت"
}
```
* **بدنه درخواست جهت گزارش پروفایل کاربر:**
```json
{
  "target_type": "USER_PROFILE",
  "reported_user_id": "c1f7b820-22e3-4f9e-a89b-944a956d2994",
  "reason": "IMPERSONATION",
  "details": "جعل نام و نشان رسمی کارگزاری آگاه"
}
```

---

### هـ) ماژول مدیریت ادمین و تنظیمات پویا (`/api/v1/admin`)

* **ویرایش اطلاعات کاربر:** `PATCH /api/v1/admin/users/:id` (ویرایش نام، هندل، تلفن، کلمه عبور و رده).
* **مدیریت توییت:** `PATCH /api/v1/admin/posts/:id` (ویرایش متن، مخفی‌سازی، پین سراسری).
* **تنظیمات پویا و کدهای رنگی تم:** `GET /api/v1/config/theme` و `PUT /api/v1/admin/config/theme`.
* **ویرایش متن قوانین:** `PUT /api/v1/admin/config/terms`.
* **تست کنسول هوش مصنوعی:** `POST /api/v1/admin/ai/test-prompt` و `POST /api/v1/admin/ai/trigger-morning-brief`.
* **همگام‌سازی دستی نمادهای بورس (AllSymbols):** `POST /api/v1/admin/market/sync` (دریافت و به‌روزرسانی غیرمخرب نمادها و صنایع از Api.BrsApi.ir با حداقل تاخیر ۱۰۰ms).
* **همگام‌سازی جامع تک‌نماد (Symbol.php):** `POST /api/v1/admin/market/sync-symbol` (دریافت اطلاعات زیرصنعت و اطلاعیه‌های مجامع کدال).

---

### و) ماژول داده‌های بازار بورس و صنایع (`/api/v1/stocks`)

#### ۱. فهرست نمادها با فیلتر صنایع و مرتب‌سازی
* **مسیر:** `GET /api/v1/stocks?industry=فلزات+اساسی&sort=volume&limit=50`
* **پارامترها:** `search` (جستجوی نماد، نام شرکت یا ISIN)، `industry` (فیلتر بر اساس نام صنعت/گروه)، `sort` (`volume`, `trade_value`, `change_desc`, `change_asc`, `market_cap`).

#### ۲. فهرست کلیه صنایع و گروه‌های بورسی
* **مسیر:** `GET /api/v1/stocks/sectors`
* **پاسخ:** فهرست نام هر صنعت به همراه تعداد نمادهای فعال ذیل آن صنعت.

#### ۳. تابلوی جامع نماد بورسی، مظنه ۵ سطحی و مجامع
* **مسیر:** `GET /api/v1/stocks/:symbol`
* **پاسخ:** اطلاعات قیمت، درصد نوسان، وضعیت نماد، تابلوی ۵ سطحی خرید و فروش (`order_book`)، آمار حقیقی/حقوقی (`client_types`)، اطلاعیه‌های مجامع کدال (`assemblies`) و آمار گفتگوهای کاربران.

