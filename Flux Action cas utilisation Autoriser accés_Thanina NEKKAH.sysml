
package ATMD_Flux_GestionAutorisations {

    private import ScalarValues::Boolean;

    action gererAutorisations {

        // Conditions
        attribute gestionnaireHabilite : Boolean;
        attribute gestionnaireNonHabilite : Boolean;
        attribute droitsValides : Boolean;
        attribute droitsInvalides : Boolean;
        attribute enregistrementReussi : Boolean;
        attribute enregistrementEchoue : Boolean;
        attribute synchronisationReussie : Boolean;
        attribute synchronisationEchouee : Boolean;

        // Actions
        action demanderModificationDroits;
        action verifierHabilitationGestionnaire;
        action selectionnerUtilisateur;
        action consulterDroitsExistants;
        action definirNouveauxDroits;
        action verifierCoherenceDroits;
        action enregistrerNouveauxDroits;
        action transmettreDroitsControleur;
        action confirmerModification;
        action refuserModification;
        action signalerDroitsInvalides;
        action signalerEchecEnregistrement;
        action signalerEchecSynchronisation;
        action enregistrerEchec;

        // Decisions
        decide decideHabilitation;
        decide decideDroits;
        decide decideEnregistrement;
        decide decideSynchronisation;

        // Fusion des chemins
        merge mergeFin;

        // Debut
        first start;

        succession start
            then demanderModificationDroits;

        succession demanderModificationDroits
            then verifierHabilitationGestionnaire;

        succession verifierHabilitationGestionnaire
            then decideHabilitation;

        // Gestionnaire habilite ?
        succession decideHabilitation
            if gestionnaireHabilite
            then selectionnerUtilisateur;

        succession decideHabilitation
            if gestionnaireNonHabilite
            then refuserModification;

        // Consultation et modification
        succession selectionnerUtilisateur
            then consulterDroitsExistants;

        succession consulterDroitsExistants
            then definirNouveauxDroits;

        succession definirNouveauxDroits
            then verifierCoherenceDroits;

        succession verifierCoherenceDroits
            then decideDroits;

        // Droits coherents ?
        succession decideDroits
            if droitsValides
            then enregistrerNouveauxDroits;

        succession decideDroits
            if droitsInvalides
            then signalerDroitsInvalides;

        // Enregistrement
        succession enregistrerNouveauxDroits
            then decideEnregistrement;

        succession decideEnregistrement
            if enregistrementReussi
            then transmettreDroitsControleur;

        succession decideEnregistrement
            if enregistrementEchoue
            then signalerEchecEnregistrement;

        // Synchronisation
        succession transmettreDroitsControleur
            then decideSynchronisation;

        succession decideSynchronisation
            if synchronisationReussie
            then confirmerModification;

        succession decideSynchronisation
            if synchronisationEchouee
            then signalerEchecSynchronisation;

        // Chemin de succes
        succession confirmerModification
            then mergeFin;

        // Chemins d'echec
        succession refuserModification
            then enregistrerEchec;

        succession signalerDroitsInvalides
            then enregistrerEchec;

        succession signalerEchecEnregistrement
            then enregistrerEchec;

        succession signalerEchecSynchronisation
            then enregistrerEchec;

        succession enregistrerEchec
            then mergeFin;

        // Fin
        succession mergeFin
            then done;
    }
}
