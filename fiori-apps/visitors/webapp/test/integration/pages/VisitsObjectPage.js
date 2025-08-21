sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'visitors',
            componentId: 'VisitsObjectPage',
            contextPath: '/Visitor/_Visits'
        },
        CustomPageDefinitions
    );
});