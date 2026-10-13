# پلتفرم اجتماعی بازار سرمایه ایران (توییت‌تحلیل / Twittahlil)
## Master Product & Architecture Blueprint

مستندات کامل، مشخصات کارکردی، سیستم طراحی و معماری نرم‌افزار این پروژه در پوشه زیر ایجاد و مستقر شده است:

📂 **`/bourse-social-docs/`**

### راهنمای دسترسی سریع به اسناد اصلی:
* **نقشه کل سیستم و راهنما:** [`/bourse-social-docs/README.md`](/bourse-social-docs/README.md)
* **ثبت تصمیمات معماری (ADR):** [`/bourse-social-docs/00-architecture-and-index/architecture-decision-log.md`](/bourse-social-docs/00-architecture-and-index/architecture-decision-log.md)
* **واژه‌نامه تخصصی و اصطلاحات فارسی:** [`/bourse-social-docs/00-architecture-and-index/glossary-and-persian-terminology.md`](/bourse-social-docs/00-architecture-and-index/glossary-and-persian-terminology.md)
* **معماری اطلاعات و ناوبری ۴ گزینه‌ای:** [`/bourse-social-docs/02-ux-and-design-system/01-information-architecture-and-navigation.md`](/bourse-social-docs/02-ux-and-design-system/01-information-architecture-and-navigation.md)
* **سیستم دیزاین اولترامارین-سیترون، فونت محلی وزیرمتن و دیزاین اتمیک:** [`/bourse-social-docs/02-ux-and-design-system/02-design-system-and-persian-tokens.md`](/bourse-social-docs/02-ux-and-design-system/02-design-system-and-persian-tokens.md)
* **مشخصات توییت‌ها، ویرایشگر و پیوست‌ها (۱۰MB):** [`/bourse-social-docs/03-features-and-functional-specs/01-posts-composer-and-sentiment-spec.md`](/bourse-social-docs/03-features-and-functional-specs/01-posts-composer-and-sentiment-spec.md)
* **مشخصات صفحه نماد و خلاصه هوش مصنوعی:** [`/bourse-social-docs/03-features-and-functional-specs/02-stocks-and-market-data-spec.md`](/bourse-social-docs/03-features-and-functional-specs/02-stocks-and-market-data-spec.md)
* **فید ۳ تبی و بخش کاوش با فیلترها:** [`/bourse-social-docs/03-features-and-functional-specs/03-feeds-discovery-and-search-spec.md`](/bourse-social-docs/03-features-and-functional-specs/03-feeds-discovery-and-search-spec.md)
* **ویزارد آنبوردینگ و تنظیمات اپلیکیشن:** [`/bourse-social-docs/03-features-and-functional-specs/08-onboarding-wizard-and-user-settings-spec.md`](/bourse-social-docs/03-features-and-functional-specs/08-onboarding-wizard-and-user-settings-spec.md)
* **پنل مدیریت جامع، CMS و کنترل هوش مصنوعی:** [`/bourse-social-docs/03-features-and-functional-specs/09-admin-backoffice-and-cms-spec.md`](/bourse-social-docs/03-features-and-functional-specs/09-admin-backoffice-and-cms-spec.md)
* **اسکیما دیتابیس PostgreSQL:** [`/bourse-social-docs/04-technical-architecture/02-data-model-and-database-schema.md`](/bourse-social-docs/04-technical-architecture/02-data-model-and-database-schema.md)
* **قراردادهای وب‌سرویس REST API:** [`/bourse-social-docs/04-technical-architecture/03-api-specifications-and-contracts.md`](/bourse-social-docs/04-technical-architecture/03-api-specifications-and-contracts.md)
* **قابلیت‌های مصوب هوش مصنوعی Gemini:** [`/bourse-social-docs/06-ai-and-gemini-features/01-gemini-ai-features-catalog-and-evaluation.md`](/bourse-social-docs/06-ai-and-gemini-features/01-gemini-ai-features-catalog-and-evaluation.md)
* **دستورالعمل اجرایی هوش مصنوعی مجری:** [`/bourse-social-docs/05-delivery-roadmap-and-testing/03-ai-coding-agent-prompts-and-conventions.md`](/bourse-social-docs/05-delivery-roadmap-and-testing/03-ai-coding-agent-prompts-and-conventions.md)

---

## 🚀 نقشه راه و برنامه‌ریزی فازبندی‌شده توسعه (Development Plan & AI Prompts)

تمامی برنامه‌های فازبندی‌شده و پرامپت‌های اجرایی آماده برای عامل هوش مصنوعی کدنویس در پوشه زیر مستقر شده‌اند:

📂 **`/development-plan/`**

### سند مادر:
* **نقشه راه جامع توسعه ۹ فازی:** [`/development-plan/development-roadmap.md`](/development-plan/development-roadmap.md)

### مشخصات و پرامپت‌های تفکیکی هر فاز:
1. **فاز ۰۱ (زیرساخت، پوسته PWA و دیزاین سیستم اتمیک):**
   * سند مشخصات فاز: [`/development-plan/phase-01.md`](/development-plan/phase-01.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-01-prompt.md`](/development-plan/phase-01-prompt.md)
2. **فاز ۰۲ (احراز هویت پیامکی، ویزارد آنبوردینگ و تنظیمات کاربر):**
   * سند مشخصات فاز: [`/development-plan/phase-02.md`](/development-plan/phase-02.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-02-prompt.md`](/development-plan/phase-02-prompt.md)
3. **فاز ۰۳ (دایرکتوری نمادها، آداپتور بازار بورس و صفحه اختصاصی نماد):**
   * سند مشخصات فاز: [`/development-plan/phase-03.md`](/development-plan/phase-03.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-03-prompt.md`](/development-plan/phase-03-prompt.md)
4. **فاز ۰۴ (ویرایشگر توییت، آپلود مستقیم اسناد ۱۰MB به S3 و هسته انتشار):**
   * سند مشخصات فاز: [`/development-plan/phase-04.md`](/development-plan/phase-04.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-04-prompt.md`](/development-plan/phase-04-prompt.md)
5. **فاز ۰۵ (موتور فیدهای ۳ تبی، کاوش، ترندها، جستجو و تعاملات اجتماعی):**
   * سند مشخصات فاز: [`/development-plan/phase-05.md`](/development-plan/phase-05.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-05-prompt.md`](/development-plan/phase-05-prompt.md)
6. **فاز ۰۶ (گراف اجتماعی، صفحه پروفایل، اعلان‌ها و احراز هویت تحلیلی):**
   * سند مشخصات فاز: [`/development-plan/phase-06.md`](/development-plan/phase-06.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-06-prompt.md`](/development-plan/phase-06-prompt.md)
7. **فاز ۰۷ (تعدیل محتوا، امنیت، فیوزهای بازار و پنل مدیریت ادمین):**
   * سند مشخصات فاز: [`/development-plan/phase-07.md`](/development-plan/phase-07.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-07-prompt.md`](/development-plan/phase-07-prompt.md)
8. **فاز ۰۸ (ادغام هوش مصنوعی Gemini، ربات صبح‌نامه و کنسول ادمین):**
   * سند مشخصات فاز: [`/development-plan/phase-08.md`](/development-plan/phase-08.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-08-prompt.md`](/development-plan/phase-08-prompt.md)
9. **فاز ۰۹ (کش آفلاین PWA، آزمون‌های تضمین کیفیت، تست بار و استقرار نهایی):**
   * سند مشخصات فاز: [`/development-plan/phase-09.md`](/development-plan/phase-09.md)
   * پرامپت اجرایی عامل کدنویس: [`/development-plan/phase-09-prompt.md`](/development-plan/phase-09-prompt.md)

---

## 📦 سورس‌کد کامل، اسکریپت نصب خودکار و راهنمای نگهداری (Application Codes)

سورس‌کد کامل و عملیاتی پلتفرم، اسکریپت نصب تعاملی و سند راهنمای نگهداری سرور در مسیرهای زیر قرار گرفته است:

* 🛠️ **اسکریپت نصب خودکار:** [`/install.sh`](/install.sh) و [`/app/install.sh`](/app/install.sh) (دارای پرامپت تعاملی برای دریافت MySQL دیتابیس cPanel، پورت، ادمین، پیامک Payamak و کلیدهای هوش مصنوعی)
* 📖 **سند جامع استقرار و دستورات SSH:** [`/implementation.md`](/implementation.md) (کدهای کامل Reverse Proxy برای `.htaccess` و Nginx، دستورات PM2، بکاپ‌گیری MySQL و مشخصات درگاه‌ها)
* 💻 **سورس‌کد کامل پروژه:** پوشه [`/app/`](/app/) (نودجی‌اس، اکسپرس، MySQL2، مایگریشن خودکار، PWA کامل و پنل ادمین)

