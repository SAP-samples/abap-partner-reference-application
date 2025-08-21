sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'musicfestivals/test/integration/FirstJourney',
        'musicfestivals/test/integration/pages/MusicFestivalList',
        'musicfestivals/test/integration/pages/MusicFestivalObjectPage',
        'musicfestivals/test/integration/pages/VisitsObjectPage'
    ],
    function (JourneyRunner, opaJourney, MusicFestivalList, MusicFestivalObjectPage, VisitsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('musicfestivals') + '/index.html'
        });


        JourneyRunner.run(
            {
                pages: {
                    onTheMusicFestivalList: MusicFestivalList,
                    onTheMusicFestivalObjectPage: MusicFestivalObjectPage,
                    onTheVisitsObjectPage: VisitsObjectPage
                }
            },
            opaJourney.run
        );
    }
);