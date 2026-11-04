
package Maintenance_Flux {

    action def consulterAlertesMaintenance {

        in anomalieDetectee : Boolean;

        action surveillerPorte;
        action collecterDonnees;
        action transmettreDonnees;
        action analyserDonnees;
        action genererAlerte;
        action enregistrerAlerte;
        action afficherAlerte;
        action consulterAlerte;
        action poursuivreSurveillance;

        decide decisionAnomalie;
        merge finMaintenance;

        first start;
        then surveillerPorte;
        then collecterDonnees;
        then transmettreDonnees;
        then analyserDonnees;
        then decisionAnomalie;

        if anomalieDetectee then genererAlerte;
        else poursuivreSurveillance;

        first genererAlerte;
        then enregistrerAlerte;
        then afficherAlerte;
        then consulterAlerte;
        then finMaintenance;

        first poursuivreSurveillance;
        then finMaintenance;

        then done;
    }
}
