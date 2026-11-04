package AccesNFC_Flux {

    action def accederAvecBadgeNFC {

        attribute autorisationValide : Boolean;

        action presenterSmartphone;
        action lireBadgeNFC;
        action transmettreIdentifiant;
        action verifierAutorisations;
        action commanderOuverture;
        action ouvrirPorte;
        action refuserAcces;

        decide decisionAutorisation;
        merge finAcces;

        first start;
        then presenterSmartphone;
        then lireBadgeNFC;
        then transmettreIdentifiant;
        then verifierAutorisations;
        then decisionAutorisation;

        if autorisationValide then commanderOuverture;
        else refuserAcces;

        first commanderOuverture;
        then ouvrirPorte;
        then finAcces;

        first refuserAcces;
        then finAcces;

        then done;
    }
}