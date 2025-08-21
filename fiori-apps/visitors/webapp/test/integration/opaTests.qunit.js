sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'visitors/test/integration/FirstJourney',
		'visitors/test/integration/pages/VisitorList',
		'visitors/test/integration/pages/VisitorObjectPage',
		'visitors/test/integration/pages/VisitsObjectPage'
    ],
    function(JourneyRunner, opaJourney, VisitorList, VisitorObjectPage, VisitsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('visitors') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheVisitorList: VisitorList,
					onTheVisitorObjectPage: VisitorObjectPage,
					onTheVisitsObjectPage: VisitsObjectPage
                }
            },
            opaJourney.run
        );
    }
);