# weekly-planner — routine spec

Spec per la routine di pianificazione settimanale. **Da istanziare solo dopo che il
canarino e2e (Task 7 del piano) è verde** — non creare la routine prima di aver visto
la skill girare a mano almeno una volta con il gate che ferma davvero.

## Forma: scheduled-task forma B (dentro l'app)

La routine gira **dentro l'app Claude**, non in CCR (cloud sandbox), perché dipende da
MCP interattivi autenticati:
- **Google Calendar** (leggere gli eventi della settimana + creare i blocchi in Fase 4).
- **Gmail** (scan email azionabili in Fase 1).

Questi MCP non sono raggiungibili dalla sandbox CCR (allowlist host). Quindi:
scheduled-task locale/in-app, non RemoteTrigger. Vedi la memory env su CCR sandbox
allowlist e su `scheduled-tasks` vs CronCreate.

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
prompt. Attenzione: comandi Bash con expansion (`$(...)`) NON vengono memorizzati e sono
richiesti a ogni run — la scrittura del weekly usa l'helper Python via comando a pattern
fisso (`cd <helpers_path> && .venv/bin/python -c "..."`); se dà problemi di ri-approvazione,
spostare l'invocazione in uno script `.sh` versionato con comando fisso.

## Ordine di attivazione

1. Canarino e2e manuale della skill (Task 7) → verde.
2. Creare la scheduled-task con il prompt sopra.
3. "Run now" una volta per pre-approvare i permessi.
4. Lasciare che il primo lunedì automatico confermi l'handoff.
