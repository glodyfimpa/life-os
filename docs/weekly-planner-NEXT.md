# weekly-planner — punto di ripartenza (deciso 2026-07-06)

Contesto catturato a caldo dopo la sessione in cui abbiamo pianificato la settimana a
mano e deciso di trasformarla in routine + skill. Da riprendere in **sessione fresca**.

## Decisione di scope (calibrata contro l'over-engineering)

Domanda posta da Glody a fine sessione: "stiamo facendo over-engineering?". Risposta:
il ridisegno completo di life-os (3 livelli, Adapter/Repository/Strategy, taglio
core/config per open-source) **sarebbe over-engineering ORA** — un sistema a utente
singolo, senza secondo tool/utente/cliente reale. Costruire l'astrazione prima del
secondo caso d'uso viola la regola "3 implementazioni concrete PRIMA di estrarre la base".

**Scope APPROVATO (fai questo):**
1. **Skill `weekly-planner`** riutilizzabile: invocabile a mano (`/weekly-planner` o
   "pianifichiamo la settimana") E dalla routine. Facade a 4 fasi:
   - Fase 1 Collect — riusa `planning-review-system` (task/progetti/quarterly) + scan
     Gmail + scan sessioni Claude ultime 2 settimane + calendario.
   - Fase 2 Weigh & Prioritize — **NUOVO**: pesatura eventi (vedi memory
     `feedback_weigh_every_calendar_event`) + ordinamento per scadenza dura + Golden Rule.
   - Fase 3 Report + **GATE handoff** — riepilogo leggibile, poi STOP: aspetta l'OK di
     Glody. NON tocca il calendario prima.
   - Fase 4 Apply (post-OK) — crea/sposta/pulisce eventi sul calendario (riusa lo Step
     4.5 export di `time-energy-manager`) + scrive weekly md nel vault + commit/push.
2. **Routine** `pianificazione-settimanale` (scheduled-task forma B, dentro l'app perché
   dipende da Calendar+Gmail MCP interattivi): lunedì **09:33** (off-minute), è un trigger
   di 3 righe che invoca la skill. Zero logica nella routine.
3. **Estrazione MINIMA** dei blocchi che la 3ª skill costringerebbe a duplicare
   (regola del tre): **Config Guard** + **Vault Filesystem Mode** sono già IDENTICI in
   `planning-review-system` e `time-energy-manager`; con weekly-planner sarebbero la 3ª
   copia → estrarli in un riferimento condiviso. Solo questi due, non tutti e sei.

**Scope RIMANDATO (NON fare finché non arriva il trigger):**
- Refactoring completo a 3 livelli (infra/dominio/orchestrazione).
- Adapter Pattern per tool diversi → **trigger: quando arriva un secondo tool reale**
  (es. Glody passa a Outlook, o un utente lo chiede).
- Strategy Pattern per regole personali iniettabili → **trigger: secondo utente reale**.
- Taglio core/config + open-core (open-source o a pagamento) → **trigger: decisione di
  prodotto esplicita di Glody** ("voglio distribuirlo"). Solo allora paga il costo di
  packaging/licenza/docs-per-estranei. Fino ad allora: tieni core e config di Glody
  separati DOVE è naturale (già lo fa il config `life-os.local.md`), senza forzare.

## Regole apprese oggi che la skill DEVE incorporare
- Fasce di lavoro SOLO 10-12 e 16-18 (memory `feedback_weigh_every_calendar_event`).
- Pesa ogni evento: natura (blocco/promemoria) · tempo · carico (handoff/cognitivo/
  fisico) · dove. No due cognitivi back-to-back. Le 4h vanno riempite pesando, non
  svuotate parcheggiando fuori fascia. Nel dubbio sul peso, chiedi.
- Fonte primaria = vault; Notion solo fallback esplicito (config life-os aggiornato).

## Come costruirlo (deciso: strangler + TDD)
- Estrai un componente alla volta, test a guardia, le 4 skill restano funzionanti a
  ogni passo. Zero big-bang. I vault-helper Python (`scripts/life_os/`) sotto TDD.

## Come riprendere
Sessione fresca in `brain/areas/tooling/plugins/life-os`, di':
"costruiamo weekly-planner, vedi docs/weekly-planner-NEXT.md" → poi `/superpowers:brainstorming`.

Prompt della routine (già disegnato, self-contained) e schema architetturale completo:
sono nella cronologia della sessione del 2026-07-06. Se serve, il calendario di quella
settimana è già stato materializzato (weekly/2026-07-06-weekly.md).
