import './stylesheets/theme.scss';
import './stylesheets/app.scss';

import jquery from 'jquery';
window.jQuery = window.$ = jquery;
top.jQuery = top.$ = jquery;

import dt from 'datatables.net-dt';

import UIkit from 'uikit';
import Icons from 'uikit/dist/js/uikit-icons';

// loads the Icon plugin
UIkit.use(Icons);

import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

const application = Application.start();
const context = require.context('../app/controllers', true, /\.js$/);
application.load(definitionsFromContext(context));

const initPage = function() {
  jQuery(() => {
    jQuery('table.datatable').DataTable();
  });
};
initPage();
document.addEventListener('turbolinks:load', initPage);
