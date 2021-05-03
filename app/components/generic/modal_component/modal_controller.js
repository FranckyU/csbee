import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    $(this.element).removeClass("hidden");
    $(this.element).parent("turbo-frame").removeAttr("src");        
  }

  disconnect() {}

  close() {
    $(this.element).addClass('hidden');
    $(this.element).remove();
  } 
}
