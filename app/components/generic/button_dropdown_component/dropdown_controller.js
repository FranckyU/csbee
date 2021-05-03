import { Controller } from "stimulus";

export default class extends Controller {
  toggle() {
    $(this.element).find("[role='menu']").toggleClass('hidden');
  } 
}
