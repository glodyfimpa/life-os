# weekly-planner — routine spec

Spec per la routine di pianificazione settimanale. **Da istanziare solo dopo che il
canarino e2e (Task 7 del piano) è verde** — non creare la routine prima di aver visto
la skill girare a mano almeno una volta con il gate che ferma davvero.

## Forma: scheduled-task local (dentro l'app) — gate sincrono nella sessione

**Stato: CREATA e attiva** (2026-07-10, taskId `pianificazione-settimanale`, `33 9 * * 1`
= lunedì mattina, jitter dello scheduler ~09:39).

La routine gira **dentro l'app Claude**, non in CCR (cloud sandbox), perché dipende da
MCP interattivi autenticati:
- **Google Calendar** (leggere gli eventi della settimana + creare i blocchi in Fase 4).
- **Gmail** (scan email azionabili in Fase 1).

Questi MCP non sono raggiungibili dalla sandbox CCR (allowlist host). Quindi:
scheduled-task locale/in-app, non RemoteTrigger.

**Il gate è SINCRONO nella sessione stessa** (deciso 2026-07-10, forma semplice): la
routine parte, propone il piano, si ferma al gate, e Glody risponde **nella sessione
della routine stessa** (il PC è acceso). Niente notifica esterna, niente seconda
invocazione, niente storage-proposta separato. Glody legge → OK/modifiche → la stessa
sessione applica.

**Vincolo local** (memory `reference_local_scheduled_task_interrupted_by_active_session`):
un task local condivide l'app con la chat attiva. Se lunedì alle 09:39 Glody sta usando
Claude in un'altra conversazione, il run si **interrompe a metà**. Rimedio: lasciare l'app
idle a quell'ora, o far partire il run quando lo si vede.

**Trigger per la versione asincrona** (rimandata, YAGNI): quando servirà che giri a **PC
spento** (spostamento su VPS/cloud). Solo allora si paga il costo di gate asincrono a 2
invocazioni + notifica esterna (Telegram bridge/push) + storage della proposta nel weekly
file. Fino ad allora: forma local sincrona.

## Schedule

- **Quando:** lunedì **09:33** (off-minute — evita lo spike fleet API sui minuti :00/:30).
- **Ricorrenza:** settimanale.
- Cron equivalente: `33 9 * * 1`.

## Prompt della routine (3 righe, zero logica)

Tutta la logica vive nella skill. La routine è solo un trigger:

```
È lunedì mattina: pianifichiamo la settimana.
Invoca la skill weekly-planner (workflow completo, 4 fasi) per la settimana che inizia oggi.
Fermati al gate dopo la Fase 3 (Report) e aspetta il mio OK prima di toccare calendario o vault.
```

## Pre-approvazione permessi

Alla prima esecuzione manuale ("Run now"), pre-approvare i tool usati (Calendar read/write,
Gmail search, filesystem del vault) così i run automatici non si bloccano su permission
prompt. La scrittura del weekly usa il Write tool (markdown diretto, nessun helper Python),
quindi niente comandi Bash con expansion da ri-approvare.

## Ordine di attivazione

1. ✅ Canarino a secco della skill (2026-07-10) → verde: Config Guard risolve i tool,
   Fase 1 legge il calendario reale, il gate NON scrive nulla (né file weekly né eventi).
2. ✅ Scheduled-task creata (2026-07-10, `pianificazione-settimanale`, lunedì mattina).
3. TODO Glody: "Run now" una volta per pre-approvare Calendar+Gmail — ma questo è già il
   primo run REALE (pianifica davvero la settimana), non un canarino. Farlo quando pronto.
4. Lasciare che il primo lunedì automatico confermi l'handoff (app aperta e idle).
