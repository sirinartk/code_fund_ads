import { Controller } from 'stimulus';
import SimpleBar from 'simplebar';
import 'simplebar/dist/simplebar.css';

export default class extends Controller {
  connect() {
    new SimpleBar(this.element);
  }
}
