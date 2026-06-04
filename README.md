KOCAELİ ÜNİVERSİTESİ
Bilişim Sistemleri Mühendisliği
TBL331 - Veritabanı Yönetim Sistemleri

WEB VE iOS DESTEKLİ E-TİCARET SİSTEMİ
Proje Konusu: Online Alışveriş Sitesi
Grup No: 33

Grup Üyeleri ve Görevleri
Sueda Tut: Veritabanı tabloları, SQL kodları, tablo ilişkileri, ER diyagramı ve dummy data
Zeynep Güngör: Web frontend tasarımı, arayüz düzenlemeleri ve iOS/mobil arayüz çalışmaları
Zeynep Bulut: Backend geliştirme, API bağlantıları, Supabase entegrasyonu ve test süreçleri

İçindekiler
1. Proje Özeti 
2. Problem Tanımı 
3. Projenin Amacı 
4. Kullanılan Teknolojiler 
5. Geliştirme Ortamı 
6. Genel Sistem Yapısı 
7. Veritabanı Tasarımı 
8. Tablolar ve İlişkiler 
9. Normalizasyon Açıklaması 
10. Kullanılan Kısıtlayıcılar 
11. Index Kullanımı 
12. View Kullanımı 
13. Trigger Kullanımı 
14. Stored Procedure Kullanımı 
15. Akış Şeması 
16. Yazılım Mimarisi 
17. API Yapısı 
18. Arayüz Görselleri 
19. Yapılan Araştırmalar 
20. Test Verileri 
21. Projenin Çalıştırılması 
22. GitHub Proje Yapısı 
23. Görev Dağılımı 
24. Sonuç 
25. Referanslar 
26. Teslim Dosyaları

1. Proje Özeti
Bu proje, kullanıcıların ürünleri görüntüleyebildiği, kategoriye göre filtreleme ve ürün arama yapabildiği, ürünleri sepete ekleyebildiği, sipariş oluşturabildiği ve sipariş geçmişini takip edebildiği web ve iOS destekli bir e-ticaret sistemidir. Sistem aynı zamanda admin rolüne sahip kullanıcıların ürün ekleme, ürün güncelleme, ürün silme ve stok kontrolü gibi yönetim işlemlerini gerçekleştirebilmesini hedeflemektedir. 

Proje kapsamında kullanıcı arayüzü, backend servisleri ve ilişkisel veritabanı birlikte ele alınmıştır. Web ve mobil arayüz Flutter tabanlı geliştirilmiş; backend tarafında Node.js ve Express.js ile API yapısı kurulmuş; veritabanı tarafında PostgreSQL/Supabase kullanılarak kullanıcı, ürün, kategori, sepet, sipariş ve adres süreçleri modellenmiştir. 

2. Problem Tanımı
E-ticaret sistemlerinde ürünlerin doğru kategoriler altında listelenmesi, kullanıcıların sepet ve sipariş süreçlerinin tutarlı şekilde yönetilmesi, stok bilgilerinin güncel kalması ve kullanıcı bilgilerinin güvenli bir şekilde saklanması önemlidir. Bu süreçler yalnızca görsel arayüzle çözülemez; arka planda doğru tasarlanmış bir veritabanı ve düzenli çalışan bir backend yapısı gerekir. 

Bu proje kapsamında çözülmesi hedeflenen problem, kullanıcıların web veya iOS arayüzü üzerinden ürünleri kolayca inceleyebileceği, sepete ürün ekleyip çıkarabileceği, sipariş verebileceği ve sipariş geçmişini görüntüleyebileceği bir e-ticaret altyapısı oluşturmaktır. Admin tarafında ise ürün yönetimi ve stok kontrolü gibi işlemler desteklenerek sistemin yönetilebilir olması amaçlanmıştır.

3. Projenin Amacı
*Web ve iOS platformlarında çalışabilecek temel bir e-ticaret sistemi geliştirmek. 
*Kullanıcıların kayıt olma, giriş yapma, ürün görüntüleme, filtreleme, sepete ekleme ve sipariş verme işlemlerini gerçekleştirebilmesini sağlamak. 
*Admin kullanıcıların ürün ekleme, ürün güncelleme, ürün silme ve stok kontrolü yapabilmesini sağlamak. 
*Veritabanı tarafında 5N normalizasyon kurallarına uygun, ilişkisel ve tutarlı bir yapı kurmak. 
*Index, View, Trigger, Function ve Stored Procedure yapılarını amaca uygun şekilde kullanmak. 
*Gerçekçi dummy data ile sistemin test edilebilirliğini göstermek.

4. Kullanılan Teknolojiler
Frontend / Mobil: Flutter, Dart, Responsive arayüz tasarımı, Web ve iOS arayüzleri
Backend: Node.js, Express.js, REST API yapısı
Veritabanı: PostgreSQL, Supabase
Versiyon Kontrol: Git, Github
Geliştirme Araçları: Visual Studio Code, npm, Flutter SDK, Tarayıcı, Supabase Dashboard

5. Geliştirme Ortamı
Proje geliştirme sürecinde Visual Studio Code, GitHub, Supabase Dashboard, PostgreSQL, Node.js, npm, Flutter SDK ve web tarayıcısı kullanılmıştır. Backend ve frontend/mobil yapıları ayrı terminal süreçleriyle çalıştırılmıştır. Veritabanı işlemleri Supabase paneli ve SQL betikleri üzerinden yürütülmüştür.

6. Genel Sistem Yapısı 
Sistem üç temel katmandan oluşmaktadır: kullanıcı arayüzü, backend/API katmanı ve veritabanı katmanı. 

6.1 Kullanıcı Arayüzü 
Kullanıcılar web veya iOS arayüzü üzerinden sisteme erişir. Ürün listeleme, ürün arama, kategori filtreleme, ürün detaylarını görüntüleme, sepete ekleme/çıkarma ve sipariş oluşturma işlemleri bu katmanda gerçekleştirilir. 

6.2 Backend Katmanı 
Backend katmanı istemciden gelen istekleri alır, gerekli kontrolleri yapar ve veritabanı ile iletişimi sağlar. Ürün, kategori, sepet, sipariş ve kullanıcı işlemleri REST API uç noktaları üzerinden yürütülür. 

6.3 Veritabanı Katmanı 
Veritabanı katmanı kullanıcılar, ürünler, kategoriler, sepetler, siparişler, sipariş detayları ve adres bilgileri gibi kalıcı verileri saklar. Tablolar arası ilişkiler Foreign Key yapılarıyla kurulmuştur.

7. Veritabanı Tasarımı
Proje kapsamında toplam 9 tablo kullanılarak ilişkisel bir veritabanı tasarımı yapılmıştır. Tablolar, veri tekrarını azaltacak ve ilişkileri açık gösterecek şekilde ayrılmıştır.
users: Sisteme kayıtlı kullanıcı bilgilerini tutar.
categories: Ürün kategorilerini tutar.
products:Ürün bilgilerini ve stok durumunu tutar.
cart: Kullanıcının aktif sepet bilgisini tutar.
cart_items: Sepette bulunan ürünlerin detaylarını tutar.
orders: Kullanıcıların oluşturduğu siparişleri tutar.
order_items: Sipariş içindeki ürün detaylarını tutar.
addresses: Kullanıcılara ait adres bilgilerini tutar.
shops: Mağazalara ait temel bilgileri tutar.

***************VERİTABANI ER DİYAGRAMI GÖRSELİ****

8. Tablolar ve İlişkiler
***TABLO FOTOSU***
