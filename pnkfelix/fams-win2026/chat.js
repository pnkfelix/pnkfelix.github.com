class ClaudeChat {
    constructor() {
        this.apiKey = null;
        this.currentSlide = null;
        this.presentationContent = null;
        this.chatHistory = [];
        this.avatarStates = {
            default: '🤖',
            cold: '🥶',
            family: '👨‍👩‍👧‍👦',
            travel: '✈️',
            excited: '🤩',
            thinking: '🤔',
            loading: '⏳'
        };
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.checkStoredApiKey();
    }

    setupEventListeners() {
        // API Key setup
        document.getElementById('connectButton').addEventListener('click', () => this.connectToAPI());
        document.getElementById('apiKeyInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') this.connectToAPI();
        });
        document.getElementById('disconnectButton').addEventListener('click', () => this.disconnect());

        // Chat functionality
        document.getElementById('sendMessage').addEventListener('click', () => this.sendMessage());
        document.getElementById('messageInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') this.sendMessage();
        });
    }

    checkStoredApiKey() {
        // Check if API key is stored in localStorage (optional convenience)
        const storedKey = localStorage.getItem('claude_api_key');
        if (storedKey) {
            document.getElementById('apiKeyInput').value = storedKey;
        }
    }

    async connectToAPI() {
        const apiKeyInput = document.getElementById('apiKeyInput');
        const connectButton = document.getElementById('connectButton');
        const apiKey = apiKeyInput.value.trim();

        if (!apiKey || !apiKey.startsWith('sk-ant-')) {
            alert('Please enter a valid Claude API key (starts with sk-ant-)');
            return;
        }

        connectButton.disabled = true;
        connectButton.textContent = 'Testing connection...';

        try {
            // Test the API key with a simple request
            const response = await fetch('https://api.anthropic.com/v1/messages', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-api-key': apiKey,
                    'anthropic-version': '2023-06-01'
                },
                body: JSON.stringify({
                    model: 'claude-3-sonnet-20240229',
                    max_tokens: 10,
                    messages: [{ role: 'user', content: 'Hello' }]
                })
            });

            if (response.ok) {
                this.apiKey = apiKey;
                // Optionally store API key (user choice)
                if (confirm('Save API key for future visits? (stored locally in your browser only)')) {
                    localStorage.setItem('claude_api_key', apiKey);
                }
                this.showChatInterface();
                this.addWelcomeMessage();
            } else {
                const error = await response.json();
                throw new Error(error.error?.message || 'Invalid API key');
            }
        } catch (error) {
            alert(`Connection failed: ${error.message}`);
            connectButton.disabled = false;
            connectButton.textContent = 'Connect';
        }
    }

    disconnect() {
        this.apiKey = null;
        localStorage.removeItem('claude_api_key');
        document.getElementById('chatContainer').style.display = 'none';
        document.getElementById('apiKeySetup').style.display = 'flex';
        document.getElementById('apiKeyInput').value = '';
        document.getElementById('connectButton').disabled = false;
        document.getElementById('connectButton').textContent = 'Connect';
        this.chatHistory = [];
    }

    showChatInterface() {
        document.getElementById('apiKeySetup').style.display = 'none';
        document.getElementById('chatContainer').style.display = 'flex';
    }

    addWelcomeMessage() {
        this.addMessage('claude', `Hi! I'm Claude, now connected and ready to help with your family trip presentation! I can see we're working on a March 2026 trip proposal. Ask me anything about the current slide, travel planning, or family vacation ideas!`);
    }

    onSlideChange(slideIndex, slideData) {
        this.currentSlide = slideIndex;
        this.presentationContent = slideData;
        
        // Update avatar based on slide content
        this.updateAvatar(slideData.raw);
        
        // Add a subtle message about slide change if chat is active
        if (this.apiKey && this.chatHistory.length > 1) {
            this.addMessage('system', `📄 Now viewing slide ${slideIndex + 1}: "${this.getSlideTitle(slideData.raw)}"`);
        }
    }

    getSlideTitle(slideContent) {
        const titleMatch = slideContent.match(/^#+ (.+)/m);
        return titleMatch ? titleMatch[1] : 'Untitled slide';
    }

    updateAvatar(slideContent) {
        const content = slideContent.toLowerCase();
        let newState = 'default';
        
        if (content.includes('cold') || content.includes('winter') || content.includes('snow')) {
            newState = 'cold';
        } else if (content.includes('family') || content.includes('kids') || content.includes('children')) {
            newState = 'family';
        } else if (content.includes('travel') || content.includes('flight') || content.includes('trip')) {
            newState = 'travel';
        } else if (content.includes('exciting') || content.includes('amazing') || content.includes('wonderful')) {
            newState = 'excited';
        }
        
        document.getElementById('claudeAvatar').textContent = this.avatarStates[newState];
    }

    async sendMessage() {
        if (!this.apiKey) return;

        const input = document.getElementById('messageInput');
        const message = input.value.trim();
        
        if (!message) return;
        
        this.addMessage('user', message);
        input.value = '';
        
        // Show loading state
        document.getElementById('claudeAvatar').textContent = this.avatarStates.loading;
        const sendButton = document.getElementById('sendMessage');
        sendButton.disabled = true;
        
        try {
            await this.getClaudeResponse(message);
        } catch (error) {
            this.addMessage('claude', `Sorry, I encountered an error: ${error.message}. Please try again.`);
        } finally {
            sendButton.disabled = false;
            this.updateAvatar(this.presentationContent?.raw || '');
        }
    }

    async getClaudeResponse(userMessage) {
        // Build context about the presentation and current slide
        const systemPrompt = this.buildSystemPrompt();
        
        // Build conversation history for Claude
        const messages = [
            { role: 'user', content: systemPrompt },
            ...this.chatHistory
                .filter(msg => msg.sender === 'user' || msg.sender === 'claude')
                .slice(-10) // Keep last 10 exchanges
                .map(msg => ({
                    role: msg.sender === 'user' ? 'user' : 'assistant',
                    content: msg.text
                })),
            { role: 'user', content: userMessage }
        ];

        const response = await fetch('https://api.anthropic.com/v1/messages', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-api-key': this.apiKey,
                'anthropic-version': '2023-06-01'
            },
            body: JSON.stringify({
                model: 'claude-3-sonnet-20240229',
                max_tokens: 1000,
                messages: messages
            })
        });

        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error?.message || 'API request failed');
        }

        const data = await response.json();
        const claudeResponse = data.content[0].text;
        
        this.addMessage('claude', claudeResponse);
    }

    buildSystemPrompt() {
        const currentSlideInfo = this.presentationContent ? 
            `Current slide (${this.currentSlide + 1}): "${this.getSlideTitle(this.presentationContent.raw)}"\n\nSlide content:\n${this.presentationContent.raw}` :
            'No slide selected yet.';

        return `You are Claude, an AI assistant embedded in a family trip pitch deck presentation. You're helping with a March 2026 family vacation proposal involving 4 families.

Context:
- This is an interactive presentation where families are pitching destinations
- The user is currently viewing a specific slide in the presentation
- You should be enthusiastic about family travel and helpful with trip planning
- You can discuss the current slide content, travel logistics, family activities, budgeting, etc.
- Keep responses conversational and engaging, appropriate for a family setting

${currentSlideInfo}

Respond as Claude, being helpful, enthusiastic about family travel, and contextually aware of the current slide content.`;
    }

    addMessage(sender, text) {
        const messagesContainer = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        
        if (sender === 'system') {
            messageDiv.className = 'message system-message';
            messageDiv.innerHTML = `<div class="message-content system-content">${text}</div>`;
        } else {
            messageDiv.className = `message ${sender}-message`;
            messageDiv.innerHTML = `<div class="message-content">${this.formatMessage(text)}</div>`;
        }
        
        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        
        this.chatHistory.push({ sender, text, timestamp: new Date() });
    }

    formatMessage(text) {
        // Basic markdown-like formatting
        return text
            .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
            .replace(/\*(.*?)\*/g, '<em>$1</em>')
            .replace(/`(.*?)`/g, '<code>$1</code>')
            .replace(/\n/g, '<br>');
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.claudeChat = new ClaudeChat();
});