import { Controller } from "@hotwired/stimulus";

import { faker } from "https://cdn.jsdelivr.net/npm/@faker-js/faker@9.6.0/+esm";

export default class extends Controller {
  static targets = ["email", "username", "firstName", "lastName", "password", "passwordConfirmation"];

  fillRandom() {
    this.emailTarget.value = faker.internet.email();
    this.usernameTarget.value = faker.internet.userName({min: 3, max: 7});
    this.firstNameTarget.value = faker.person.firstName();
    this.lastNameTarget.value = faker.person.lastName();

    let password = '123123';
    this.passwordTarget.value = password;
    this.passwordConfirmationTarget.value = password;
  }
}