# مدل داده، دیاگرام روابط و اسکیما پایگاه داده
## Data Model, Relational Schema & Database Design

این سند ساختار جداول پایگاه داده رابطه‌ای (MySQL / MariaDB)، کلیدهای خارجی، محدودیت‌ها، انوم‌ها، ایندکس‌های بهینه‌سازی‌شده متنی فارسی، چرخه حیات کاربران مسدودشده، نقل‌قول‌های حذف‌شده و جداول گزارش‌ها، نشان‌شده‌ها، ممیزی و حسابرسی را تدوین می‌کند.

---

## ۱. دیاگرام روابط موجودیت‌ها (Entity-Relationship Diagram)

```text
  ┌──────────────┐          1:N          ┌──────────────────────┐
  │    users     ├──────────────────────►│        posts         │
  └──────┬───────┘                       └──────────┬───────────┘
         │                                          │
         ├──────────────┬──────────────┐ ┌──────────┴───────────┐
         │ 1:1          │ 1:N          │ │ M:N                  │ 1:N
         ▼              ▼              ▼ ▼                      ▼
  ┌──────────────┐┌──────────────┐┌──────────────┐      ┌──────────────┐
  │user_settings ││ user_follows ││ post_stocks  │      │    likes     │
  │ (تنظیمات)    ││(دنبال‌کردن)  ││(اتصال به سهم)│      │    reposts   │
  └──────────────┘└──────────────┘└──────┬───────┘      │   bookmarks  │
         │                               │              └──────────────┘
         ├───────────────────────────────┤                      │
         │ 1:N                           │ M:1                  │ 1:N
         ▼                               ▼                      ▼
  ┌──────────────────────┐        ┌──────────────┐      ┌──────────────┐
  │verification_requests │        │    stocks    │      │   reports    │
  │ (درخواست‌های نشان)   │        │ (بانک نمادها)│      │ (گزارش تخلف) │
  └──────────────────────┘        └──────────────┘      └──────────────┘
         │                                                      │
         └───────────────────────────────┬──────────────────────┘
                                         │ 1:N
                                         ▼
                                  ┌──────────────┐
                                  │  audit_logs  │
                                  │(لاگ حسابرسی) │
                                  └──────────────┘
```

---

## ۲. مشخصات موتور دیتابیس و انکودینگ (MySQL / MariaDB Engine & Collation)

* **موتور ذخیره‌سازی:** `InnoDB` جهت پشتیبانی کامل از تراکنش‌های ACID، کلیدهای خارجی (Foreign Keys) و قفل در سطح ردیف (Row-level Locking).
* **مجموعه کاراکترها و تطبیق (Charset & Collation):** `utf8mb4` با تطبیق `utf8mb4_unicode_ci` جهت ذخیره‌سازی بی‌نقص حروف الفبای فارسی، علائم نگارشی، نیم‌فاصله (`ZWNJ`)، ایموجی‌ها و جستجوی غیرحساس به حروف بزرگ و کوچک در کَش‌تگ‌ها و نام شرکت‌ها.
* **سازگاری کامل با هاستینگ cPanel:** ساختار داده‌ها به صورت کاملاً استاندارد با قابلیت اجرا روی هاست‌های اشتراکی cPanel و سرورهای اختصاصی طراحی شده است.

---

## ۳. تعریف جداول اصلی پایگاه داده (MySQL DDL Schemas)

### ۱. جدول کاربران (`users`)
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  phone VARCHAR(20) NULL UNIQUE,
  username VARCHAR(50) NOT NULL UNIQUE,
  display_name VARCHAR(100) NOT NULL,
  bio TEXT NULL,
  avatar_url VARCHAR(255) DEFAULT '/uploads/default-avatar.png',
  banner_url VARCHAR(255) NULL,
  user_type ENUM('normal', 'analyst', 'financial_institution', 'official_issuer', 'admin', 'bot') DEFAULT 'normal',
  is_verified TINYINT(1) DEFAULT 0,
  badge_type ENUM('none', 'blue', 'gold', 'emerald') DEFAULT 'none',
  is_banned TINYINT(1) DEFAULT 0,
  role ENUM('user', 'moderator', 'admin') DEFAULT 'user',
  password_hash VARCHAR(255) NULL,
  trading_experience VARCHAR(50) DEFAULT 'متوسط',
  market_focus VARCHAR(100) DEFAULT 'بورس تهران',
  onboarding_completed TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_username (username),
  INDEX idx_phone (phone),
  INDEX idx_badge_type (badge_type),
  INDEX idx_banned (is_banned)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۲. جدول نمادهای بورسی (`stocks`)
```sql
CREATE TABLE stocks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  symbol VARCHAR(50) UNIQUE NOT NULL,             -- مثال: فولاد (l18)
  persian_name VARCHAR(150) NOT NULL,             -- مثال: فولاد مبارکه اصفهان (l30)
  latin_name VARCHAR(150) NULL,                   -- نام لاتین شرکت (l30_en)
  isin VARCHAR(30) UNIQUE,                        -- کد بین‌المللی ۱۲ رقمی (isin)
  tsetmc_id VARCHAR(50) NULL,                     -- شناسه داخلی TSETMC (id)
  market_type VARCHAR(50) DEFAULT 'بورس',         -- بورس / فرابورس (m)
  board_name VARCHAR(100) NULL,                   -- نام تابلو (m_board)
  industry VARCHAR(100) DEFAULT 'سایر',           -- گروه صنعت / Sector (cs)
  industry_id INT NULL,                           -- شناسه صنعت (cs_id)
  sub_industry VARCHAR(100) NULL,                 -- زیرگروه صنعت (cs_sub)
  last_price DECIMAL(15,2) NOT NULL DEFAULT 0,    -- آخرین معامله به ریال (pl)
  close_price DECIMAL(15,2) NOT NULL DEFAULT 0,   -- قیمت پایانی به ریال (pc)
  yesterday_price DECIMAL(15,2) DEFAULT 0,        -- قیمت دیروز به ریال (py)
  first_price DECIMAL(15,2) DEFAULT 0,            -- اولین قیمت به ریال (pf)
  change_percent DECIMAL(6,2) NOT NULL DEFAULT 0, -- درصد تغییر آخرین معامله (plp)
  volume BIGINT NOT NULL DEFAULT 0,               -- حجم معاملات (tvol)
  trade_value BIGINT NOT NULL DEFAULT 0,          -- ارزش معاملات به ریال (tval)
  trades_count INT DEFAULT 0,                     -- تعداد معاملات (tno)
  market_cap BIGINT DEFAULT 0,                    -- ارزش بازار به ریال (mv)
  floating_shares_percent DECIMAL(5,2) NULL,      -- درصد سهام شناور (ff)
  pe_ratio DECIMAL(8,2) NULL,                     -- P/E سهم (pe)
  group_pe DECIMAL(8,2) NULL,                     -- P/E گروه (g_pe)
  eps DECIMAL(10,2) NULL,                         -- EPS سهم (eps)
  ps_ratio DECIMAL(8,2) NULL,                     -- P/S سهم (ps)
  high_price DECIMAL(15,2) DEFAULT 0,             -- بالاترین قیمت روز (pmax)
  low_price DECIMAL(15,2) DEFAULT 0,              -- پایین‌ترین قیمت روز (pmin)
  market_state VARCHAR(50) DEFAULT 'مجاز',        -- وضعیت نماد (state)
  order_book_json LONGTEXT NULL,                  -- تابلوی مظنه ۵ سطحی Bids & Asks
  client_types_json LONGTEXT NULL,                -- آمار خریداران و فروشندگان حقیقی/حقوقی
  assemblies_json LONGTEXT NULL,                  -- اطلاعیه‌های مجمع و گزارش‌های کدال (assembly)
  last_market_time VARCHAR(20) NULL,              -- زمان ثبت آخرین معامله
  is_active TINYINT(1) DEFAULT 1,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_stocks_symbol ON stocks(symbol);
CREATE INDEX idx_stocks_persian_name ON stocks(persian_name);
CREATE INDEX idx_stocks_industry ON stocks(industry);
CREATE INDEX idx_stocks_change_percent ON stocks(change_percent);
CREATE INDEX idx_stocks_volume ON stocks(volume);
```

### ۳. جدول توییت‌ها (`posts`)
```sql
CREATE TABLE posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT NOT NULL,
  reply_to_id INT NULL,
  quote_post_id INT NULL,
  likes_count INT DEFAULT 0,
  replies_count INT DEFAULT 0,
  reposts_count INT DEFAULT 0,
  bookmarks_count INT DEFAULT 0,
  views_count INT DEFAULT 0,
  is_deleted TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reply_to_id) REFERENCES posts(id) ON DELETE SET NULL,
  FOREIGN KEY (quote_post_id) REFERENCES posts(id) ON DELETE SET NULL,
  INDEX idx_user_posts (user_id, created_at),
  INDEX idx_created_at (created_at),
  INDEX idx_views (views_count),
  FULLTEXT INDEX ft_content (content)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

> **قوانین چرخه حیات و نمایش توییت‌ها (Lifecycle & Visibility Rules):**
> 1. **توییت‌های کاربران مسدودشده (Banned Users):** در تمامی کوئری‌های واکشی فیدها، شرط `users.is_banned = 0` اعمال می‌شود. به محض مسدود شدن کاربر (`is_banned = 1`) توسط ادمین، کلیه توییت‌های تاریخی او به صورت آبشاری از تمامی فیدهای عمومی و جستجو مخفی می‌شوند.
> 2. **توییت‌های نقل‌قول‌شده حذف‌شده (Orphaned Quoted Tweets):** در صورتی که توییت اصلی منبع حذف شود (`is_deleted = 1` یا `quote_post_id` نامعتبر گردد)، کارت نقل‌قول توییت مقصد حذف نمی‌شود بلکه یک کادر جایگزین خاکستری با پیام *«این توییت توسط نویسنده حذف شده است»* نمایش می‌یابد (گزینه Option A).

### ۴. جدول پیوست‌های رسانه‌ای و اسناد (`post_attachments`)
```sql
CREATE TABLE post_attachments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  file_url VARCHAR(255) NOT NULL,
  file_name VARCHAR(255) NOT NULL,
  file_size INT NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۵. جدول پیوند توییت به نمادها (`post_stocks`)
```sql
CREATE TABLE post_stocks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  symbol VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  INDEX idx_symbol_posts (symbol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۶. جدول هشتگ‌های عمومی موضوعی (`post_hashtags`)
```sql
CREATE TABLE post_hashtags (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  tag VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  INDEX idx_tag (tag)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۷. جدول دنبال‌کردن کاربران (`follows`) و دنبال‌کردن نمادها (`stock_follows`)
```sql
CREATE TABLE follows (
  id INT AUTO_INCREMENT PRIMARY KEY,
  follower_id INT NOT NULL,
  following_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_follower_following (follower_id, following_id),
  FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE stock_follows (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  symbol VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_stock (user_id, symbol),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۸. جدول لایک‌ها (`likes`) و نشان‌شده‌ها (`bookmarks`)
```sql
CREATE TABLE likes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  post_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_post_like (user_id, post_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE bookmarks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  post_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_post_bm (user_id, post_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۹. جدول درخواست‌های احراز هویت و نشان تایید (`verification_requests`)
```sql
CREATE TABLE verification_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  requested_type ENUM('analyst', 'financial_institution', 'official_issuer') NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  national_id VARCHAR(20) NOT NULL,
  company_name VARCHAR(150) NULL,
  license_number VARCHAR(100) NULL,
  documents_url TEXT NULL,
  description TEXT NULL,
  status ENUM('pending', 'needs_revision', 'approved', 'rejected') DEFAULT 'pending',
  admin_notes TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_req_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۰. جدول گزارش‌های تخلف محتوا و کاربران (`reports`)
```sql
CREATE TABLE reports (
  id INT AUTO_INCREMENT PRIMARY KEY,
  reporter_id INT NOT NULL,
  target_type ENUM('POST', 'USER_PROFILE') NOT NULL DEFAULT 'POST',
  post_id INT NULL,
  reported_user_id INT NULL,
  reason VARCHAR(100) NOT NULL,
  description TEXT NULL,
  status ENUM('pending', 'reviewed', 'dismissed') DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE SET NULL,
  FOREIGN KEY (reported_user_id) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_report_status (status),
  INDEX idx_report_target (target_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۱. جدول اعلان‌های کاربران (`notifications`)
```sql
CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  actor_id INT NULL,
  type ENUM('like', 'reply', 'repost', 'follow', 'mention', 'system') NOT NULL,
  post_id INT NULL,
  message VARCHAR(255) NOT NULL,
  is_read TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (actor_id) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  INDEX idx_user_read (user_id, is_read, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۲. جدول تنظیمات پویای سیستم (`system_configs`)
```sql
CREATE TABLE system_configs (
  key_name VARCHAR(100) PRIMARY KEY,
  key_value LONGTEXT NOT NULL,
  description VARCHAR(255) NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۳. جدول خلاصه‌های هوش مصنوعی نمادها (`ai_summaries`)
```sql
CREATE TABLE ai_summaries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  symbol VARCHAR(50) NOT NULL,
  summary_content TEXT NOT NULL,
  post_count INT DEFAULT 0,
  model_used VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_symbol_summary (symbol, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۴. جدول لاگ‌های امنیتی و حسابرسی (`security_logs`)
```sql
CREATE TABLE security_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  event_type VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NULL,
  ip_address VARCHAR(50) NULL,
  user_agent VARCHAR(255) NULL,
  status VARCHAR(50) NOT NULL,
  details TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_created_at_logs (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۵. جدول کدهای احراز هویت پیامکی (`otp_codes`)
```sql
CREATE TABLE otp_codes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  phone VARCHAR(20) NOT NULL,
  code VARCHAR(10) NOT NULL,
  attempts INT DEFAULT 0,
  is_used TINYINT(1) DEFAULT 0,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_phone_active (phone, is_used, expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۶. جدول سشن‌های فعال کاربران (`sessions`)
```sql
CREATE TABLE sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(255) NOT NULL UNIQUE,
  user_agent VARCHAR(255) NULL,
  ip_address VARCHAR(50) NULL,
  expires_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_token (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۷. جدول تنظیمات اختصاصی کاربر (`user_settings`)
```sql
CREATE TABLE user_settings (
  user_id INT PRIMARY KEY,
  theme_mode ENUM('light', 'dark', 'system') DEFAULT 'system',
  favorite_sectors_json TEXT NULL,            -- آرایه‌ای از صنایع مورد علاقه JSON جهت هدایت فید مخصوص شما
  favorite_symbols_json TEXT NULL,            -- آرایه‌ای از نمادهای دیدبان برگزیده JSON
  email_notifications TINYINT(1) DEFAULT 0,
  push_notifications TINYINT(1) DEFAULT 1,
  reply_privacy ENUM('everyone', 'following', 'mentioned') DEFAULT 'everyone',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۸. جدول لاگ حسابرسی اقدامات مدیران (`audit_logs`)
```sql
CREATE TABLE audit_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT NOT NULL,
  action VARCHAR(100) NOT NULL,               -- مثال: BAN_USER, EDIT_POST, APPROVE_KYC, UPDATE_THEME
  target_type VARCHAR(50) NOT NULL,           -- USER, POST, KYC_REQUEST, CONFIG
  target_id INT NULL,
  details TEXT NULL,                          -- توضیحات مشروح اقدام و مقادیر قبلی/جدید
  ip_address VARCHAR(50) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (admin_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_audit_action (action),
  INDEX idx_audit_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۱۹. جدول مسدودسازی کاربران متقابل (`user_blocks`)
```sql
CREATE TABLE user_blocks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  blocker_id INT NOT NULL,
  blocked_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_block (blocker_id, blocked_id),
  FOREIGN KEY (blocker_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (blocked_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۲۰. جدول بی‌صدا کردن کاربران و کلمات (`user_mutes`)
```sql
CREATE TABLE user_mutes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  muted_user_id INT NULL,                     -- شناسه کاربری که بی‌صدا شده است
  muted_word VARCHAR(100) NULL,               -- کلمه یا هشتگی که توسط کاربر خاموش شده
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (muted_user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_mute_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### ۲۱. جدول آرشیو صبح‌نامه‌های تحلیلی ربات هوش مصنوعی (`ai_morning_briefs`)
```sql
CREATE TABLE ai_morning_briefs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NULL,                           -- شناسه توییت رسمی منتشرشده توسط @twittahlil_bot
  brief_content TEXT NOT NULL,
  symbols_tagged_json TEXT NULL,              -- آرایه نمادهای تگ‌شده در صبح‌نامه
  model_used VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE SET NULL,
  INDEX idx_morning_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

