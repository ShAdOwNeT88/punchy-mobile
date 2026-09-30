# Tessere digitali — v0.3

## Problema

Molte attività usano ancora tessere cartacee da timbrare: piscine e palestre (ingressi, mensilità),
bar, ristoranti, negozi, parrucchieri (raccolte punti "10 timbri → 1 omaggio"). Sul fronte c'è chi
emette la tessera, spesso un numero e il nome del titolare; sul retro una griglia di caselle che lo
staff timbra. Punchy ne è la versione digitale.

Il primo cliente è una piscina, ma il modello non è legato a un settore: tutto ciò che è specifico
di un'attività (nome, tagline, contatti, premio) è **contenuto** servito dal backend; la categoria
dell'attività cambia solo icona e decorazione, mai il comportamento.

## Modello

Una **tessera** (`DigitalCard`) ha:

- un **emittente** (`issuer`) con nome, categoria (`pool`, `gym`, `studio`, `cafe`, `restaurant`,
  `shop`, `beauty`, `other`), tagline e contatti opzionali;
- un **programma** (`program`) che dice come si riempiono le caselle:
  - `entries` — pacchetto di ingressi prepagati, una casella per ingresso;
  - `monthly` — abbonamento, una casella per mensilità pagata (con periodo e importo);
  - `loyalty` — raccolta timbri, una casella per acquisto; a tessera piena si ottiene il `reward`;
- un numero di caselle, i timbri (data, periodo, importo, iniziali dell'operatore);
- opzionali: numero tessera, titolare, premio, scadenza. Le tessere fedeltà sono spesso anonime;
- un aspetto scelto dall'emittente, che non cambia il comportamento:
  - `style`: la palette di colori;
  - `design`: `gradient` (card a tutto colore, lo stile dell'app) o `paper` (tessera stampata bianca
    con una fascia illustrata in alto, il box "TESSERA N.", il fumetto "Info" e il titolare scritto a
    penna sulle righe a galleggianti: la tessera cartacea della piscina Life, primo cliente);
  - `stampStyle`: `round` (timbro tondo) o `signature` (sigla a penna dell'operatore);
  - `issuer.emblem`: il simbolo del logo (`leaf`, `wave`, `star`, `heart`, `bolt`, `crown`); senza,
    si usa l'icona della categoria. In futuro lo sostituirà l'immagine del logo servita dal backend.

`entries` e `monthly` sono **abbonamenti**; `loyalty` è **fedeltà**. La lista si filtra per questi
due gruppi.

## Funzionalità v0.2

1. **Login** — email + password. Validazione lato client (email ben formata, password ≥ 6
   caratteri). La sessione è persistita: al riavvio si apre direttamente la lista.
2. **Le mie tessere** — lista con barra di avanzamento ("4 di 12 ingressi", "8 di 12 mesi pagati",
   "7 di 10 timbri"; "Premio pronto!" su una fedeltà piena). Filtri Tutte / Abbonamenti / Fedeltà,
   mostrati solo se l'utente ha tessere di entrambi i gruppi. Pull-to-refresh, stato vuoto, errore
   con "Riprova", logout.
3. **Dettaglio tessera** — la tessera vola dalla lista (Hero) e si gira in 3D con un tap, uno swipe
   orizzontale o il selettore Fronte/Retro.
   - Fronte: emittente, tagline, contatto ("Info"), numero; titolare se presente, altrimenti il
     premio. Ogni elemento opzionale assente semplicemente non compare.
   - Retro: griglia dei timbri, con colonne scelte in base al numero di caselle (12 → 4×3,
     10 → 5×2, 6 → 3×2). Intestazione INGRESSI / MENSILITÀ / RACCOLTA TIMBRI. Su una fedeltà
     l'ultima casella mostra il premio.
   - Sotto: riepilogo (usati, rimanenti o "al premio", scadenza); per le fedeltà la card del premio
     con avanzamento, che diventa "Premio sbloccato!" a tessera piena; storico dal più recente.

Fuori scope in v0.2: tessere a punti con saldo numerico (supermercati), riscatto del premio in app,
pagamento in app, timbratura da parte dello staff (QR/NFC), notifiche, registrazione.

## Contratto backend (proposto)

Base URL da `API_BASE_URL`. Tutte le chiamate autenticate portano `Authorization: Bearer <token>`.

### `POST auth/login`

```json
// request
{ "email": "mario.rossi@example.com", "password": "••••••" }
// 200
{ "token": "…", "user": { "id": "u1", "email": "…", "firstName": "Mario", "lastName": "Rossi" } }
// 401 → credenziali errate
```

### `GET cards` → `Card[]`, `GET cards/{id}` → `Card`

```json
{
  "id": "card-cafe-01",
  "number": "0427",
  "issuer": {
    "name": "Caffè Centrale",
    "category": "pool | gym | studio | cafe | restaurant | shop | beauty | other",
    "emblem": "leaf | wave | star | heart | bolt | crown",
    "tagline": "torrefazione dal 1962",
    "contactName": "Luigi",
    "contactPhone": "345 000 0000"
  },
  "holder": { "firstName": "Mario", "lastName": "Rossi" },
  "style": "ocean | ember | violet | forest | coffee | rose",
  "design": "gradient | paper",
  "stampStyle": "round | signature",
  "program": "entries | monthly | loyalty",
  "totalSlots": 10,
  "reward": "Un caffè omaggio",
  "validUntil": "2027-06-30",
  "stamps": [
    { "date": "2026-01-05", "period": "2026-01-01", "amountCents": 4500, "operatorInitials": "SV" }
  ]
}
```

Obbligatori: `id`; per ogni timbro, `date`. Tutto il resto è opzionale. `reward` è testo già nella
lingua dell'utente.

Tolleranze del parser: `category`, `style`, `program`, `design`, `stampStyle` sconosciuti ricadono su
`other`, `ocean`, `entries`, `gradient`, `round`; un `emblem` sconosciuto è ignorato; `totalSlots` mancante vale 12 e non è mai inferiore al numero di timbri; i timbri sono
ordinati per data; stringhe vuote (numero, nomi, premio) contano come assenti.

Il payload di esempio completo è in `lib/features/cards/services/mock_cards_service.dart`.
