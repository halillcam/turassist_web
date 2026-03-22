# TurAssist Web Panel

TurAssist Web Panel, tur firmalarının operasyon süreçlerini daha düzenli ve dijital bir şekilde yönetebilmesi için geliştirilmiş web tabanlı bir yönetim sistemidir.

Bu platform sayesinde yöneticiler; tur oluşturma, katılımcı yönetimi ve operasyon süreçlerini tek bir panel üzerinden kontrol edebilir.

## Genel Bakış

TurAssist, tur organizasyonlarında sıklıkla karşılaşılan manuel ve dağınık süreçleri merkezi bir sistem altında toplamak amacıyla geliştirilmiştir.

 Web panel üzerinden firmalar:

- Tur oluşturabilir ve yönetebilir
- Katılımcıları ve kullanıcı rollerini kontrol edebilir
- Tur kapasitesini ve doluluk durumunu takip edebilir
- Operasyon süreçlerini daha düzenli şekilde yönetebilir

## Özellikler

Tur Yönetimi
- Yeni tur oluşturma, güncelleme ve silme,
- Tur tarihi, kapasite ve rehber atama işlemleri
- Kullanıcı ve Rol Yönetimi
- Rol bazlı yetkilendirme (super admin, admin, guide, customer)
- Kullanıcıları şirketlere atama
- Yetki ve erişim kontrolü

 Katılımcı Yönetimi
- Tur bazlı katılımcı takibi
- Bilet ve rezervasyon verilerinin yönetimi
- Bildirim Sistemi
- Duyuru ve bilgilendirme gönderimi
- Şirket bazlı veya genel bildirim yayını

Operasyon Yönetimi
- Tur süreçlerinin yönetimi
- Tur tamamlama taleplerinin takibi
- Rehber ve yönetici koordinasyonu


Proje, katmanlı mimari yaklaşımı ile geliştirilmiştir:

- Presentation katmanı (arayüz ve kullanıcı etkileşimi)
- Domain katmanı 
- Data katmanı (veri yönetimi ve servisler)

Bu yapı, projenin sürdürülebilirliğini ve geliştirilebilirliğini artırmayı hedefler.

## Kullanılan Teknolojiler
- Flutter (Web)
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Messaging


Kimlik doğrulama Firebase Authentication ile sağlanmaktadır.
Veri erişimi ve yetkilendirme ise Firestore Security Rules üzerinden rol bazlı olarak kontrol edilmektedir.

Kullanıcılar yalnızca yetkili oldukları verilere erişebilir.

## Demo

Projenin demo videosuna aşağıdaki bağlantı üzerinden ulaşabilirsiniz:

 # ▶️https://youtu.be/60JbPzEaCYA

Not

Bu proje, tur firmalarının operasyon süreçlerini daha verimli hale getirmek amacıyla, manuel ve mesajlaşma tabanlı yönetim yöntemlerine alternatif olarak geliştirilmiştir.
