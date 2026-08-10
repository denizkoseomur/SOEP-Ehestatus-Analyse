from pathlib import Path

content = """# SOEP-Datenanalyse: Einkommen, Lebenszufriedenheit und Ehestatus

## Projektbeschreibung

Dieses Projekt untersucht mithilfe von Daten des **Sozio-oekonomischen Panels (SOEP)**, welchen Zusammenhang Einkommen und Lebenszufriedenheit mit der Wahrscheinlichkeit haben, verheiratet zu sein.

Die Analyse entstand im Rahmen eines universitären Projekts und umfasst die vollständige empirische Auswertung von der Datenaufbereitung bis zur Schätzung und Interpretation verschiedener binärer Regressionsmodelle.

## Forschungsfrage

**Wie beeinflussen Einkommen und Lebenszufriedenheit die Wahrscheinlichkeit, verheiratet zu sein?**

Dabei wird untersucht, ob Personen mit höherem Einkommen beziehungsweise höherer Lebenszufriedenheit mit einer höheren Wahrscheinlichkeit verheiratet sind.

## Datengrundlage

Als Datengrundlage wird ein für Studierende aufbereiteter Datensatz des **Sozio-oekonomischen Panels (SOEP)** verwendet. Der Datensatz wurde im Rahmen der Lehrveranstaltung von der prüfenden Lehrkraft bereitgestellt und diente ausschließlich der Durchführung des universitären Analyseprojekts.

Die abhängige Variable gibt an, ob eine Person verheiratet ist. Als zentrale erklärende Variablen werden verwendet:

- Bruttoeinkommen
- Lebenszufriedenheit

Zusätzlich werden verschiedene Kontrollvariablen berücksichtigt, darunter:

- Alter und Alter²
- Geschlecht
- Bildung
- Erwerbsstatus
- Risikobereitschaft
- Gesundheitszustand
- Kinder im Haushalt

## Methoden

Die Analyse wurde in **R** durchgeführt und umfasst unter anderem:

- Datenbereinigung und Datenaufbereitung
- deskriptive Analyse
- Logit-Regression
- Probit-Regression
- Berechnung marginaler Effekte
- Modellvergleich
- Robustheitsanalysen
- Visualisierung und Interpretation der Ergebnisse

## Ergebnisse

Die Ergebnisse zeigen einen **positiven statistischen Zusammenhang** zwischen Einkommen, Lebenszufriedenheit und der Wahrscheinlichkeit, verheiratet zu sein.

Im vollständigen Logit-Modell ergeben sich unter anderem folgende durchschnittliche marginale Effekte:

- **Bruttoeinkommen:** ca. +0,72 Prozentpunkte je zusätzlichen 1.000 €
- **Lebenszufriedenheit:** ca. +3,17 Prozentpunkte je zusätzlichem Punkt auf der Lebenszufriedenheitsskala

Auch die Probit-Schätzung liefert qualitativ vergleichbare Ergebnisse.

Die Ergebnisse beschreiben statistische Zusammenhänge. Aufgrund des verwendeten Forschungsdesigns können daraus keine eindeutigen kausalen Effekte abgeleitet werden.

## Verwendete Technologien

- R
- RStudio
- statistische Modellierung
- Logit- und Probit-Regression
- Datenaufbereitung
- Datenvisualisierung
- empirische Wirtschaftsforschung

## Datenverfügbarkeit

Der im Projekt verwendete Datensatz ist **nicht Bestandteil dieses Repositories**.

Es handelt sich um einen für Studierende bereitgestellten SOEP-Datensatz, der im Rahmen der Lehrveranstaltung durch die prüfende Lehrkraft zur Verfügung gestellt wurde. Aufgrund der Datenschutz- und Nutzungsbestimmungen der zugrunde liegenden SOEP-Daten wird der Datensatz nicht öffentlich weitergegeben.

Das Repository enthält daher ausschließlich eigenen Analysecode sowie daraus abgeleitete und aggregierte Ergebnisse.

Weitere Informationen zum SOEP und zum Datenzugang sind beim **Deutschen Institut für Wirtschaftsforschung (DIW Berlin)** verfügbar.

## Ziel des Projekts

Das Projekt demonstriert die praktische Anwendung ökonometrischer Methoden auf reale Mikrodaten und verbindet dabei Datenaufbereitung, statistische Modellierung und wirtschaftswissenschaftliche Interpretation.
"""

path = Path("/mnt/data/README.md")
path.write_text(content, encoding="utf-8")

print(f"Datei erstellt: {path}")
