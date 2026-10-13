# توییت‌تحلیل (Twittahlil)
## مستندات جامع معماری، محصول، طراحی و توسعه پلتفرم اجتماعی بازار سرمایه ایران
### Master System Blueprint & Single Source of Truth

---

## ۱. معرفی مستندات (Documentation Overview)

این مجموعه مستندات، مرجع واحد و رسمی (**Single Source of Truth**) برای طراحی، توسعه، آزمون و استقرار پلتفرم اجتماعی تخصصی بازار بورس و اوراق بهادار ایران با برند **توییت‌تحلیل (Twittahlil)** است. هدف این پروژه، خلق یک شبکه اجتماعی آرام، مینیمال، فاخر، محتوا-محور، سریع، متمرکز بر موبایل (Mobile-First) و کاملاً راست‌به‌چپ (RTL-First) به زبان فارسی است که خلأ میان شبکه‌های اجتماعی عمومی و سامانه‌های سنتی بازار سرمایه را پر می‌کند.

این پلتفرم بر اساس فلسفه محوری زیر بنا شده است:
> **«کاربران در بازارهای مالی نه تنها افراد را دنبال می‌کنند، بلکه ایده‌ها، تحلیل‌ها و نمادهای بورسی را نیز دنبال می‌کنند.»**

---

## ۲. ساختار و درخت پوشه‌ها (Documentation Architecture)

مستندات به صورت ماژولار و تفکیک‌شده در ۵ بخش اصلی سازماندهی شده‌اند:

```text
/bourse-social-docs/
├── 00-architecture-and-index/
│   ├── README.md                                  # این سند: نمایه کل، سلسله‌مراتب حقیقت و راهنمای پروژه
│   ├── glossary-and-persian-terminology.md        # واژه‌نامه تخصصی، اصطلاحات فارسی و تعاریف رسمی
│   └── architecture-decision-log.md               # ثبت تصمیمات معماری (ADR) و سوالات باز
│
├── 01-product-strategy-and-discovery/
│   ├── 01-product-vision-and-core-loop.md         # چشم‌انداز، چرخه محوری محصول و ضدالگوها
│   ├── 02-user-personas-and-account-tiers.md      # سطوح کاربران، نشان‌ها (Badges) و ماتریس دسترسی‌ها
│   └── 03-critique-challenges-and-risk-register.md # نقد محصول، چالش‌های قانونی سازمان بورس، پیشگیری از پمپاژ و سیگنال‌فروشی
│
├── 02-ux-and-design-system/
│   ├── 01-information-architecture-and-navigation.md # معماری اطلاعات، نویگیشن تب‌بار موبایل و دسکتاپ RTL
│   ├── 02-design-system-and-persian-tokens.md    # سیستم دیزاین اولترامارین و سیترون، فونت محلی وزیرمتن و دیزاین اتمیک
│   └── 03-user-journeys-and-interaction-flows.md  # سناریوها و جریان‌های کاربر (Auth، انتشار پست، مشاهده نماد)
│
├── 03-features-and-functional-specs/
│   ├── 01-posts-composer-and-sentiment-spec.md   # مشخصات پست، ویرایشگر، اتوکامپلیت نماد، پیوست فایل، هوش مصنوعی
│   ├── 02-stocks-and-market-data-spec.md         # مشخصات صفحه نماد، نوار کمکی قیمت، خلاصه هوش مصنوعی
│   ├── 03-feeds-discovery-and-search-spec.md     # فیدها (مخصوص شما، همه، دنبال‌شده)، کاوش، سرچ فول‌تکست و هشتگ
│   ├── 04-social-graph-profiles-and-following-spec.md # پروفایل کاربری، دنبال کردن افراد و نمادها، دیدبان
│   ├── 05-interactions-notifications-bookmarks-spec.md# لایک، کامنت درختی و صفحه‌بندی، بوک‌مارک، نقل‌قول و اعلان‌ها
│   ├── 06-moderation-safety-and-compliance-spec.md# گزارش تخلف توییت/پروفایل، چرخه داده بن‌شده و سلب مسئولیت
│   ├── 07-verification-and-kyc-spec.md           # احراز هویت تحلیل‌گران، نهادها، جدول verification_requests و لاگ
│   ├── 08-onboarding-wizard-and-user-settings-spec.md # ویزارد ۳ مرحله‌ای پس از ثبت‌نام و تنظیمات اپلیکیشن
│   └── 09-admin-backoffice-and-cms-spec.md       # پنل مدیریت جامع، کنترل کاربران، رنگ پویا و تنظیمات Gemini
│
├── 04-technical-architecture/
│   ├── 01-system-architecture-and-modularity.md  # معماری فنی کلان، ماژولاریتی و استراتژی Next.js SSR سئو
│   ├── 02-data-model-and-database-schema.md      # مدل داده، اسکیما کامل DDL در MySQL / MariaDB و ایندکس‌های ۲۳ جدول پایگاه‌داده
│   ├── 03-api-specifications-and-contracts.md    # قراردادهای API، اندپوینت آپلود، هشتگ، ریپلای و گزارش
│   ├── 04-market-data-adapter-and-caching.md     # وب‌سرویس نمادها BrsApi (AllSymbols & Symbol)، کش ردیس و آپدیت غیرمخرب
│   └── 05-security-auth-and-rate-limiting.md     # امنیت، ورود پیامکی OTP (۶۰ ثانیه)، سامانه پیامک Payamak و ریت لیمیت
│
├── 05-delivery-roadmap-and-testing/
│   ├── 01-roadmap-mvp-v1-future.md               # نقشه‌راه فازبندی (MVP شامل Gemini، V1، Future) و تعاریف
│   ├── 02-testing-qa-and-acceptance-criteria.md  # معیارهای پذیرش، تست‌های کیفیت و ماتریس سناریوهای مرزی
│   └── 03-ai-coding-agent-prompts-and-conventions.md # راهنمای پیاده‌سازی و ساختار کد برای هوش مصنوعی مجری
│
└── 06-ai-and-gemini-features/
    ├── 01-gemini-ai-features-catalog-and-evaluation.md # کاتالوگ جامع ایده‌های هوش مصنوعی و ارزیابی استراتژیک
    └── 02-gemini-integration-architecture-and-prompts.md # مشخصات فنی درگاه هوش مصنوعی، پرامپت‌ها و کنترل هزینه

اسناد جانبی در ریشه مخزن:
├── implementation.md                             # راهنمای جامع استقرار در cPanel و VPS، کدهای .htaccess، Nginx و SSH
├── install.sh                                    # اسکریپت نصب تعاملی لینوکس (دریافت دیتابیس cPanel، پورت، پیامک و ادمین)
└── development-plan/                             # نقشه‌راه توسعه ۹ فاز و پرامپت‌های اجرایی آماده AI Coding Agent
```

---

## ۳. سلسله‌مراتب منبع حقیقت (Source of Truth Hierarchy)

چنانچه در حین توسعه یا مطالعه اسناد، تعارض یا ابهامی بین بخش‌های مختلف مشاهده شد، اولویت حاکمیت فنی و محصولی به ترتیب زیر تعیین می‌شود:

1. **سطح ۱ (بالاترین اولویت):** سند تصمیمات معماری (`00-architecture-and-index/architecture-decision-log.md`) — هر تصمیمی که رسماً به عنوان ADR تصویب شده، بر تمام مشخصات دیگر ارجحیت دارد.
2. **سطح ۲:** مشخصات کارکردی و مدل داده (`03-features-and-functional-specs/` و `04-technical-architecture/02-data-model-and-database-schema.md`) — تعاریف فیلدها، وضعیت‌ها و اعتبارسنجی‌ها در این اسناد حاکم هستند.
3. **سطح ۳:** سیستم طراحی و جریان‌های UX (`02-ux-and-design-system/`) — رفتار تعاملی و قواعد دیداری رابط کاربری.
4. **سطح ۴:** راهنمای نقشه راه و توسعه (`05-delivery-roadmap-and-testing/`) — مرزهای شمول MVP در برابر V1.
5. **سطح ۵:** چشم‌انداز و کشف محصول (`01-product-strategy-and-discovery/`) — فلسفه عمومی و اهداف کلان.

---

## ۴. دستورالعمل ویژه عامل‌های برنامه‌نویسی هوش مصنوعی (AI Coding Agents)

عامل هوش مصنوعی مجری برای آغاز پیاده‌سازی موظف است اصول زیر را بدون استثنا رعایت کند:
1. **عدم اختراع پیش‌فرض‌های کسب‌وکار:** هرگز قوانین تجاری یا روابط داده‌ای خارج از این اسناد جعل نکنید.
2. **پایبندی به اصل ماژولار بودن (Separation of Concerns):** کدهای بک‌اند و فرانت‌اند باید کاملاً ماژولار باشند. تغییر در ویجت اطلاعات تابلوی نماد نباید کوچک‌ترین وابستگی تخریب‌کننده‌ای بر ماژول انتشار پست ایجاد کند.
3. **رعایت دقیق استانداردهای فارسی و RTL:** تمام کامپوننت‌های فرانت‌اند باید جهت‌گیری `dir="rtl"` داشته باشند. فرمت تاریخ به صورت پیش‌فرض شمسی (جلالی) و با استفاده از کتابخانه‌های معتبر تاریخ جلالی است. اعداد مبالغ و قیمت‌ها با فرمت‌بندی استاندارد ریال و ارقام تراز `tabular-nums` نمایش می‌یابند.
4. **توسعه بر اساس فازبندی MVP:** قبل از پیاده‌سازی هر قابلیت، با مراجعه به سند `roadmap-mvp-v1-future.md` بررسی کنید که آیا آن ویژگی در محدوده MVP قرار دارد یا به فاز V1/Future موکول شده است. قابلیت‌های خارج از MVP نباید در چرخه اولیه پیاده‌سازی شوند.
