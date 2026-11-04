
package ATMD_PreviAccess_Flux {

    private import ScalarValues::Boolean;

    action accederAvecSmartphoneNFC {

        attribute smartphonePresente : Boolean;
        attribute badgeNumeriqueValide : Boolean;
        attribute badgeNumeriqueInvalide : Boolean;
        attribute accesAutorise : Boolean;
        attribute accesRefuse : Boolean;

        action detecterSmartphoneNFC;
        action lireBadgeNumerique;
        action verifierValiditeBadgeNumerique;
        action verifierDroitsAcces;
        action deverrouillerPorte;
        action enregistrerAcces;
        action refuserAcces;
        action enregistrerRefus;

        decide decideBadgeNumerique;
        decide decideAcces;
        merge mergeFin;

        first start;

        succession start
            if smartphonePresente
            then detecterSmartphoneNFC;

        succession detecterSmartphoneNFC
            then lireBadgeNumerique;

        succession lireBadgeNumerique
            then verifierValiditeBadgeNumerique;

        succession verifierValiditeBadgeNumerique
            then decideBadgeNumerique;
        succession decideBadgeNumerique
            if badgeNumeriqueValide
            then verifierDroitsAcces;

        succession decideBadgeNumerique
            if badgeNumeriqueInvalide
            then refuserAcces;
        succession verifierDroitsAcces
            then decideAcces;

        succession decideAcces
            if accesAutorise
            then deverrouillerPorte;

        succession decideAcces
            if accesRefuse
            then refuserAcces;
        succession deverrouillerPorte
            then enregistrerAcces;

        succession enregistrerAcces
            then mergeFin;
        succession refuserAcces
            then enregistrerRefus;
        succession enregistrerRefus
            then mergeFin;
        succession mergeFin
            then done;
    }
}
