import consumer from "channels/consumer";

let resetFunc;

consumer.subscriptions.create("AppearancesChannel", {
  initialized() {
    this.timer = null;
  },

  connected() {
    resetFunc = () => this.resetTimer();
    this.install();
    window.addEventListener("turbo:load", resetFunc);
  },

  disconnected() {
    this.uninstall();
  },

  rejected() {
    this.uninstall();
  },

  received(data) {},

  online() {
    console.log("online");
    this.perform("online");
  },

  away() {
    console.log("away");
    this.perform("away");
  },

  offline() {
    console.log("offline");
    this.perform("offline");
  },

  uninstall() {
    console.log("uninstall");
    const shouldRun = document.getElementById("appearances_channel");
    if (!shouldRun) {
      clearTimeout(this.timer);
      this.perform("offline");
    }
  },

  install() {
    console.log("install");
    ["turbo:load"].forEach(event =>
      window.addEventListener(event, resetFunc)
    );
    this.resetTimer();
  },

  resetTimer() {
    const shouldRun = document.getElementById("appearances_channel");
    if (!shouldRun) return;

    const changedByUser = shouldRun.dataset.statusChanged === "true";
    const userStatus = shouldRun.dataset.status;
    if (!changedByUser) {
      console.log("here");
      this.online();
      clearTimeout(this.timer);

      this.timer = setTimeout(() => this.away(), 120_000);
    }else{
      this.changeStatus(userStatus);
    }
  },
  changeStatus(status) {
    console.log("changeStatus", status);
    switch (status) {
      case 'away':
        this.perform("away");
        break;
      case 'brb':
        this.perform("brb");
        break;
      default:
        this.perform("offline");
    }
  },
});