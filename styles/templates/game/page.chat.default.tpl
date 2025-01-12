{block name="title" prepend}{$LNG.lm_chat}{/block}
{block name="content"}
    <div style="width:300px"><a href="?page=chat&chat_mode=0"
            style="    width: 48%;
    display: inline-block;
    text-align: center;margin:1%;box-sizing: border-box;
    border: 1px solid #000;   {if $chat_mode == 0}background: #212428; {else} background: rgba(13, 16, 20, 0.95);{/if}  ">General</a><a href="?page=chat&chat_mode=1"
            style="    width: 48%;
    display: inline-block;
    text-align: center; margin:1%;box-sizing: border-box;
    border: 1px solid #000;     {if $chat_mode == 0} background:rgba(13, 16, 20, 0.95);{else} background:#212428;{/if}">Alliance</a></div>
    <div id="chat-container" style="      width: 300px;
    background: #212423ee;
    height: 300px;
    overflow-y: scroll;
box-sizing: border-box;
    border: 1px solid #000;">
        <div id="message-list">

        </div>
    </div>
    <form id="chat_send" action="?page=chat" method="post">

        <textarea style="  box-sizing: border-box;  background: rgba(13, 16, 20, 0.65); width: 300px;"
            name="message"></textarea>
    </form>
    <script>
        // Fetch initial 100 messages (already done in PHP)
        var lastMessageId = lastMessageId ?? 0;
        var ownid = {$ownid};
        var chat_mode = {$chat_mode};
        // Function to fetch new messages
        function fetchNewMessages(interval = 0) {
            $.ajax({
                url: '?page=chat&mode=getmessages&ajax=1&chat_mode=' + chat_mode,
                type: 'GET',
                data: { lastMessageId: lastMessageId },
                success: function(data) {
                    console.log(data);
                    const messages = data;
                    if (messages.length > 0) {
                        const messageList = $('#message-list');
                        const lastId = messages[messages.length - 1].id;

                        messages.forEach(function(message) {
                            lastMessageId = message.id > lastMessageId ? message.id : lastMessageId;
                            if (message.sender_id == ownid) {
                                messageList.append(
                                    '<div style="    background: rgba(13, 16, 20, 0.95);    text-align: right;    margin: 1px;    padding: 2px;">' +
                                    message.username + " " + message.send_time.substr(11, 5) +
                                    '<br>' + message.message + '</div>');
                            } else {
                                messageList.append(
                                    '<div style="    background: rgba(13, 16, 20, 0.65);    margin: 1px;    padding: 2px;">' +
                                    message.username + " " + message.send_time.substr(11, 5) +
                                    '<br><pre>' + message.message + '</pre></div>');
                            }
                        });

                        // Update the lastMessageId with the ID of the last fetched message
                        $('#last-message-id').val(lastId);
                        // Scroll to the bottom of the message list
                        scrollToBottom($('#chat-container'));
                    }

                },
                error: function() {
                    console.error('Failed to fetch new messages');

                }

            });
            if (interval == 1) {
                setTimeout(() => {
                    fetchNewMessages(1)
                }, 2000);
            }
        }

        fetchNewMessages(1);
        // Function to scroll an element to its bottom
        function scrollToBottom(element) {
            if (element.length > 0) { // Check if the element exists
                element.scrollTop(element.prop('scrollHeight'));
            } else {
                console.warn('#message-list not found');
            }
        }



        // Handle form submission via AJAX
        $('#chat_send').on('submit', function(e) {
            e.preventDefault();
            const message = $('textarea[name="message"]').val();
            if (message.trim() === '') return;
            $.ajax({
                url: '?page=chat&ajax=1&chat_mode=' + chat_mode,
                type: 'POST',
                data: { message: message },
                success: function() {
                    // Clear the textarea after sending
                    $('textarea[name="message"]').val('');
                    // Fetch new messages to update the chat display
                    fetchNewMessages();
                },
                error: function() {
                    console.error('Failed to send message');
                }
            });
        });

        // Handle keydown event for textarea
        $('textarea[name="message"]').on('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault(); // Prevent the default "Enter" behavior which is newline
                $('#chat_send').trigger('submit'); // Trigger form submission
            }
        });
    </script>

{/block}