# eSeminars
Seminarski rad iz predmeta Razvoj Softvera II. Ova platforma omogućava korisnicima da se besplatno edukuju uz seminare koji se nude.

# Upustvo za pokretanje
• Klonirati ovaj repozitorij

• Raspakovati `fit-build-2025-07-04-env.zip`, a zatim file `.env` postaviti u \eSeminars  [Upozorenje: U slučaju da operativni sistem obriše . ispred env dodati je]

<img src="https://github.com/user-attachments/assets/5492c792-38c4-408e-a2a4-8fa484e132df" alt="Screenshot" width="400"/>


• Pokrenuti docker desktop i otvoriti \eSeminars\eSeminars u terminalu i pokrenuti komandu 
```bash
docker-compose up --build
```

• Nakon uspješnog pokretanja dockera raspakovati `fit-build-2025-07-04-desktop.zip`, pokrenuti `eseminars_desktop.exe` iz foldera Release. Unijeti korisničke podatke za aministratora kako bi pristupili aplikaciji.

• Prije pokretanja mobilne aplikacije povesti računa o tome da već ne postoji aplikacija na emulatoru, u suprotom deinstalirajte je. Raspakovati `fit-build-2025-07-04-mobile.zip` i prevući `app-release.apk` iz foldera flutter apk u emulator da se aplikacija instalira. Nakon instalacije unijeti korisničke podatke za organizatora ili administratora.

# Napomene
• Desktop aplikaciji može pristupiti samo administrator.

• Nakon kreiranog seminara od strane organizatora treba biti odobren od strane administratora da bi bio dostupan korisnicima.

• Organizator je u stanju uređivati seminar kada je isti na čekanju za odobrenje od strane administracije

• Mobilnoj aplikaciji mogu pristupiti samo organizator i korisnici.

• Historija seminara za organizatora predstavlja seminare čiji je datum prošao, a oni su bili kreatori istih. Za korisnika znači da su datumi seminara prosli,a prisustvovali su.

# Podaci za prijavu
## Desktop
### Administrator
Email: `admin@gmail.com`

Lozinka: `admin123A!`

## Mobilna
### Organizator
Email: `organizator@gmail.com`

Lozinka: `organizator123A!`

### Korisnik
Email: `korisnik@gmail.com`

Lozinka: `korisnik123!`

# RabbitMQ

• Servis RabbitMQ korišten je u svrhu slanja emailova korisnicima čije su rezervacije za seminar odobrene od strane administratora ili orgranizatora.
