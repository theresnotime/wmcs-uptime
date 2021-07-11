<template>
    <form @submit.prevent="submit">

        <div class="modal fade" tabindex="-1" ref="modal" data-bs-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Setup Notification</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                            <div class="mb-3">
                                <label for="type" class="form-label">Notification Type</label>
                                <select class="form-select"  id="type" v-model="notification.type">
                                    <option value="telegram">Telegram</option>
                                    <option value="webhook">Webhook</option>
                                    <option value="smtp">Email (SMTP)</option>
                                    <option value="discord">Discord</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="name" class="form-label">Friendly Name</label>
                                <input type="text" class="form-control" id="name" required v-model="notification.name">
                            </div>

                            <template v-if="notification.type === 'telegram'">
                                <div class="mb-3">
                                    <label for="telegram-bot-token" class="form-label">Bot Token</label>
                                    <input type="text" class="form-control" id="telegram-bot-token" required v-model="notification.telegramBotToken">
                                    <div class="form-text">You can get a token from <a href="https://t.me/BotFather" target="_blank">https://t.me/BotFather</a>.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="telegram-chat-id" class="form-label">Chat ID</label>

                                    <div class="input-group mb-3">
                                        <input type="text" class="form-control" id="telegram-chat-id" required v-model="notification.telegramChatID">
                                        <button class="btn btn-outline-secondary" type="button" @click="autoGetTelegramChatID" v-if="notification.telegramBotToken">Auto Get</button>
                                    </div>

                                    <div class="form-text">
                                        Support Direct Chat / Group / Channel's Chat ID

                                        <p style="margin-top: 8px;">
                                            You can get your chat id by sending message to the bot and go to this url to view the chat_id:
                                        </p>

                                        <p style="margin-top: 8px;">

                                            <template v-if="notification.telegramBotToken">
                                                <a :href="telegramGetUpdatesURL" target="_blank">{{ telegramGetUpdatesURL }}</a>
                                            </template>

                                            <template v-else>
                                                {{ telegramGetUpdatesURL }}
                                            </template>
                                        </p>
                                    </div>
                                </div>
                            </template>

                        <template v-if="notification.type === 'webhook'">
                            <div class="mb-3">
                                <label for="webhook-url" class="form-label">Post URL</label>
                                <input type="url" pattern="https?://.+"  class="form-control" id="webhook-url" required v-model="notification.webhookURL">

                            </div>

                            <div class="mb-3">
                                <label for="webhook-content-type" class="form-label">Content Type</label>
                                <select class="form-select"  id="webhook-content-type" v-model="notification.webhookContentType" required>
                                    <option value="json">application/json</option>
                                    <option value="form-data">multipart/form-data</option>
                                </select>

                                <div class="form-text">
                                    <p>"application/json" is good for any modern http servers such as express.js</p>
                                    <p>"multipart/form-data" is good for PHP, you just need to parse the json by <strong>json_decode($_POST['data'])</strong></p>
                                </div>
                            </div>
                        </template>

                        <template v-if="notification.type === 'smtp'">
                            <div class="mb-3">
                                <label for="hostname" class="form-label">Hostname</label>
                                <input type="text" class="form-control" id="hostname" required v-model="notification.smtpHost">
                            </div>

                            <div class="mb-3">
                                <label for="port" class="form-label">Port</label>
                                <input type="number" class="form-control" id="port" v-model="notification.smtpPort" required min="0" max="65535" step="1">
                            </div>

                            <div class="mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="" id="secure"  v-model="notification.smtpSecure">
                                    <label class="form-check-label" for="secure">
                                        Secure
                                    </label>
                                </div>
                                <div class="form-text">Generally, true for 465, false for other ports.</div>
                            </div>

                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" required v-model="notification.smtpUsername" autocomplete="false">
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" required v-model="notification.smtpPassword" autocomplete="false">
                            </div>

                            <div class="mb-3">
                                <label for="from-email" class="form-label">From Email</label>
                                <input type="email" class="form-control" id="from-email" required v-model="notification.smtpFrom" autocomplete="false">
                            </div>

                            <div class="mb-3">
                                <label for="to-email" class="form-label">To Email</label>
                                <input type="email" class="form-control" id="to-email" required v-model="notification.smtpTo" autocomplete="false">
                            </div>

                        </template>

                        <template v-if="notification.type === 'discord'">
                            <div class="mb-3">
                                <label for="discord-token" class="form-label">Discord Bot Token</label>
                                <input type="text" class="form-control" id="discord-token" required v-model="notification.discordToken" autocomplete="false">
                                <div class="form-text">You should create a Discord app and create a bot from <a href="https://discord.com/developers/applications" target="_blank">here</a>.</div>
                            </div>

                            <div class="mb-3">
                                <label for="discordChannelID" class="form-label">Channel ID</label>
                                <input type="text" class="form-control" id="discordChannelID" required v-model="notification.discordChannelID" autocomplete="false">
                                <div class="form-text">
                                    You should add the bot to your channel. <br />
                                    <a href="https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-" target="_blank">Where can I find the channel id?</a><br />
                                    <a href="https://discordapi.com/permissions.html#8" target="_blank">How to add a bot to your channel?</a>
                                </div>
                            </div>
                        </template>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" @click="deleteConfirm" :disabled="processing" v-if="id">Delete</button>
                        <button type="button" class="btn btn-warning" @click="test" :disabled="processing">Test</button>
                        <button type="submit" class="btn btn-primary" :disabled="processing">Save</button>
                    </div>
                </div>
            </div>
        </div>

    </form>

    <Confirm ref="confirmDelete" @yes="deleteNotification" btn-style="btn-danger">Are you sure want to delete this notification for all monitors?</Confirm>
</template>

<script>
import { Modal } from 'bootstrap'
import { ucfirst } from "../../server/util";
import axios from "axios";
import { useToast } from 'vue-toastification'
import Confirm from "./Confirm.vue";
const toast = useToast()

export default {
    components: {Confirm},
    props: {

    },
    data() {
        return {
            model: null,
            processing: false,
            id: null,
            notification: {
                name: "",
                type: null,
            },
        }
    },
    mounted() {
        this.modal = new Modal(this.$refs.modal)

        // TODO: for edit
        this.$root.getSocket().emit("getSettings", "notification", (data) => {
          //  this.notification = data
        })


    },
    methods: {

        deleteConfirm() {
            this.modal.hide();
            this.$refs.confirmDelete.show()
        },

        show(notificationID) {
            if (notificationID) {
                this.id = notificationID;

                for (let n of this.$root.notificationList) {
                    if (n.id === notificationID) {
                        this.notification = JSON.parse(n.config);
                        break;
                    }
                }
            } else {
                this.id = null;
                this.notification = {
                    name: "",
                    type: null,
                }

                // Default set to Telegram
                this.notification.type = "telegram"
            }

            this.modal.show()
        },

        submit() {
            this.processing = true;
            this.$root.getSocket().emit("addNotification", this.notification, this.id, (res) => {
                this.$root.toastRes(res)
                this.processing = false;

                if (res.ok) {
                    this.modal.hide()
                }
            })
        },

        test() {
            this.processing = true;
            this.$root.getSocket().emit("testNotification", this.notification, (res) => {
                this.$root.toastRes(res)
                this.processing = false;
            })
        },

        deleteNotification() {
            this.processing = true;
            this.$root.getSocket().emit("deleteNotification", this.id, (res) => {
                this.$root.toastRes(res)
                this.processing = false;

                if (res.ok) {
                    this.modal.hide()
                }
            })
        },

        async autoGetTelegramChatID() {
            try {
                let res = await axios.get(this.telegramGetUpdatesURL)

                if (res.data.result.length >= 1) {
                    let update = res.data.result[res.data.result.length - 1]

                    if (update.channel_post) {
                        this.notification.telegramChatID = update.channel_post.chat.id;
                    } else if (update.message) {
                        this.notification.telegramChatID = update.message.chat.id;
                    } else {
                        throw new Error("Chat ID is not found, please send a message to this bot first")
                    }

                } else {
                    throw new Error("Chat ID is not found, please send a message to this bot first")
                }

            } catch (error) {
                toast.error(error.message)
            }

        },

    },
    computed: {
        telegramGetUpdatesURL() {
            let token = "<YOUR BOT TOKEN HERE>"

            if (this.notification.telegramBotToken) {
                token = this.notification.telegramBotToken;
            }

            return `https://api.telegram.org/bot${token}/getUpdates`;
        },
    },
    watch: {
        "notification.type"(to, from) {
            let oldName;

            if (from) {
                oldName =  `My ${ucfirst(from)} Alert (1)`;
            } else {
                oldName = "";
            }

            if (! this.notification.name || this.notification.name === oldName) {
                this.notification.name = `My ${ucfirst(to)} Alert (1)`
            }
        }
    }
}
</script>

<style scoped>

</style>