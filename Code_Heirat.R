library(marginaleffects)
library(ggplot2) # nur für labs-Befehl -> Verschönerung im Graphen
library(lmtest)

daten = read.csv2("Thema8_2024.csv")


###########################
###1. Datensatz anpassen###
###########################

#Zu erklärende Variable (y) so codieren, dass aus dem Datensatz nur die Kategorien
#0 (kein Partner) und 2 (Lebenspartner) in == 0 (nicht verheiratet) und Kategorie 1
# in == 1 (verheiratet) gesetzt werden. Die anderen Kategorien von "partner" sind 
# hier eine Verzerrung (5 = unklar, 2 = trifft nicht zu) -> NA
daten$verheiratet = NA
daten$verheiratet[daten$partner == 1] <- 1
daten$verheiratet[daten$partner %in% c(0, 2)] <- 0


#Variable Alter erstellen
daten$alter = 2024 - daten$gebjahr

#Einkommen/ 1000, damit eine Einheit 1.000 Euro monatl. Bruttoeink. entspricht
daten$brutto_ein = daten$brutto_ein / 1000

#Lebenszufriedenheit numerisch angeben für eine bessere Interpretation
daten$lebenszufr = as.numeric(as.character(daten$lebenszufr))

###########################
#######2. Hypothese########
###########################

#H0: ß_brutto_ein = 0 und ß_lebenszufr = 0
#Bruttoeinkommen und Lebenszufriedenheit haben gemeinsam keinen statistisch 
#signifikanten Effekt auf die Wahrscheinlichkeit verheiratet zu sein.

#H1: ß_brutto_ein != 0 oder ß_lebenszufr != 0
#Mindestens einer der beiden Variablen hat einen signifikanten Effekt auf die
#Wahrscheinlichkeit, verheiratet zu sein.


#Signifikanzniveau: 5%; a = 0.05

###########################
#########3. Modell#########
###########################

# Logit-Modell
modell = glm(verheiratet ~ brutto_ein + lebenszufr + alter + I(alter^2) + 
               sex + bildung + erwerb + risiko + gesundheit + kind_0_13,
        data = daten, family = binomial(link = "logit"))

summary(modell)
#Nur Vorzeichen der Estimates und Signifikanz interpretierbar

summary(modell)$coefficients[c("brutto_ein", "lebenszufr"), ]
#Positive Vorzeichen für beide Koeffizienten, p-Wert auf allen Signifikanzniveaus
#signifikant verschieden von 0 -> Haben signifikanten Einfluss auf "verheiratet"

modell_blank = glm(verheiratet ~ 1, data = daten ,  family = binomial(link = "logit"))
summary(modell_blank) # AIC: 12165

###AIC Vergleich:
AIC(modell, modell_blank)
#AIC(modell) = 10118.28 < 12166.73 = AIC(modell_blank)
#Das Volle Modell hat kleineren AIC Wert als das Nullmodell 
#Spricht deutlich für bessere Modellanpassung

par(mfrow = c(2,2))
plot(modell)

###########################
###4. Marginale Effekte####
###########################

#Marginale Effekte für Einkommen und Lebenszufriedenheit
me = avg_slopes(modell, 
           variables = c("brutto_ein", "lebenszufr"),
           type = "response")

me_r = avg_slopes(modell, type = "response")
me
#Interpretation: 
# Lebenszufriedenheit:
# Wenn Lebenszufriedenheit um 1 Skalenpunkt steigt, steigt die Wahrscheinl.
# verheiratet zu sein im Durchschnitt um 3.17 Prozentpunkte, c.p. 
# Statistisch signifikant mit einem p-Wert < 0.001
#Das 95%-Konfidenzintervall liegt zwischen 2.59 und 3.76 Pp.

#Einkommen:
# Wenn das monatl. Bruttoeinkommen um 1000 Euro steigt, erhöht sich die 
# Wahrscheinlichkeit verheiratet zu sein im Durchschnitt um 0.72 Prozentpunkte, c.p.
# Statistisch signifikant mit einem p-Wert von < 0.001
#Das 95%- Konfidenzintervall liegt zwischen 0.31 und 1.13 Prozentpunkte.


#Überprüfung Strang 1: Einkommen und Wahrscheinlichkeit "verheiratet"
#Graph für Einkommen:


plot_slopes(modell,
            variables = "brutto_ein",
            condition = list(brutto_ein = seq(0, 20, by = 0.5)),
            conf_level = 0.95,
            type = "response") +
  labs(
    title = "Marginaler Effekt des Bruttoeinkommen",
    subtitle = "Effekt auf Wahrscheinlichkeit, verheiratet zu sein",
    x = "Bruttoeinkommen in 1.000 Euro",
    y = "Änderung marginaler Effekt auf die Wahrscheinlichkeit")

#Zeigt Verlauf der Änderung der Marginalen Effekte auf die Wahrscheinlichkeit
#verheiratet zu sein
#Marginale Effekt des Bruttoeink. ist durchgehend positiv, nimmt mit steigendem Einkommen ab
#Zusätzliches monatl. Bruttoeinkommen von 1000 Euro erhöht die Wahrscheinlichkeit,
#verheiratet zu sein, je nach Einkommensniveau um 0.8 bis 0.9 Prozentpunkte.

#Überprüfung Strang 2: Lebenszufr und Wahrscheinlichkeit "verheiratet"
#Graph für Lebenszufriedenheit
plot_slopes(modell,
            variables = "lebenszufr",
            condition = "lebenszufr",
            conf_level = 0.95,
            type = "response") +
  labs(
    title = "Marginaler Effekt der Lebenszufriedenheit",
    subtitle = "Effekt auf die Wahrscheinlichkeit, verheiratet zu sein",
    x = "Lebenszufriedenheit",
    y = "Marginaler Effekt auf die Wahrscheinlichkeit")

#Der marignale Effekt ist durchgehend positiv. Effekt ist am stärksten bei 
#5 bis 7 Punkten. Der EFfekt hängt aber vom Ausgangsniveau ab. 
#Effekt nimmt ab ca. 7.5 Punkte auf der Lebenszufriedenheitsskala wieder ab.


###########################
#########5. Tests##########
###########################
#OVB
# Modell ohne Kontrollvariablen
modell_kurz = glm(verheiratet ~ brutto_ein + lebenszufr,
                  data = daten, family = binomial(link = "logit"))

# Modell mit Kontrollvariablen = modell

# Koeffizienten vergleichen
coef(modell_kurz)
coef(modell)

#Interpretation: 
#brutto_ein: Koeff. steigt von 0.03 auf 0.037
#Hinweis darauf, dass Koeffizient stärker auf Aufnahme der Kontrollvariablen 
#reagiert (ca. 22% Relativ. Änderung)


#Lebenszufriedenheit: Koeff steigt von 0.15 auf 0.16 -> Geringe Veränderung
#Koeffizient nicht sehr stark durch Aufnahme der Kontrollvariablen beeinflusst 
#(ca. 6% rel. Änderung)


#LR-Test
res_modell = glm(verheiratet ~ alter + I(alter^2) + sex + bildung + erwerb + 
                   risiko + gesundheit + kind_0_13,
                 data = daten, family = binomial(link = "logit"))

lrtest(res_modell, modell)

#Ergebnis: Chisq = 123.16 mit p-Wert <0.001 -> signifikant, H0 wird abgelehnt
#Einkommen & Lebenszufriedenheit verbessern das Modell gemeinsam signifikant
#Mindestens einer der beiden ist statistisch signifikant verschieden von 0.


###########################
########6. Probit##########
###########################


# Probit-Modell mit gleicher Spezifikation wie dein Logit-Modell
probit_modell = glm(verheiratet ~ brutto_ein + lebenszufr + alter + I(alter^2) +
                      sex + bildung + erwerb + risiko + gesundheit + kind_0_13,
                    data = daten, family = binomial(link = "probit"))

summary(probit_modell)


# Marginale Effekte Probit
me_probit = avg_slopes(probit_modell,
                       variables = c("brutto_ein", "lebenszufr"),
                       type = "response")

# Vergleichstabelle
me_logit_df = data.frame(Modell = "Logit", me)
me_probit_df = data.frame(Modell = "Probit", me_probit)

vergleich_me = rbind(me_logit_df, me_probit_df)

vergleich_me[, c("Modell", "term", "estimate", "std.error", 
                 "p.value", "conf.low", "conf.high")]

#Im Probitmodell sieht man kleine Abweichungen der estimates vom Logitmodell der, 
#Ergebnisse bleiben aber signifikant und positiv.

#AIC Vergleich zu Logit

AIC(modell, probit_modell)
#Logit Modell bleibt im AIC Vergleich leicht besser

# restringiertes Probit-Modell ohne Einkommen und Lebenszufriedenheit
res_probit = glm(verheiratet ~ alter + I(alter^2) + sex + bildung + erwerb +
                   risiko + gesundheit + kind_0_13,
                 data = daten, family = binomial(link = "probit"))

# LR-Test
lrtest(res_probit, probit_modell)

#Auch im LR-Test wird die Nullhypothese verworfen. Bruttoeinkommen und Lebenszufr.
#verbessern damit das Probitmodell signifikant.


###########################
####7. Leverage prüfen#####
###########################

#Beobachtung 6353 ist im Residualplot auffällig. Es wird überprüft,
#ob sich die Ergebnisse statistisch signifikant unterscheiden, wenn
#diese Beobachtung ausgelassen wird.

# Modell ohne Beobachtung 6353
modell_ohne6353 = glm(verheiratet ~ brutto_ein + lebenszufr +
                        alter + I(alter^2) + sex + bildung + erwerb +
                        risiko + gesundheit + kind_0_13,
                      data = daten[-6353, ],family = binomial(link = "logit"))

# Koeffizienten vergleichen
summary(modell)$coefficients[c("brutto_ein", "lebenszufr"), ]
summary(modell_ohne6353)$coefficients[c("brutto_ein", "lebenszufr"), ]

#Die Beobachtung 6353 wurde entfernt und ein neues Logit-Modell geschätzt.
#Die Koeffizienten unterscheiden sich nur leicht. Daher gibt es keinen Hiwneis, 
#dass die Hauptergebnisse ausschlaggebend von der entfernten Beobachtung 
#beeinflusst wird.
