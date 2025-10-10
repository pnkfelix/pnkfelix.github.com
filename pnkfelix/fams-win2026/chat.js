class ClaudeChat {
    constructor() {
        this.currentSlide = null;
        this.presentationContent = null;
        this.chatHistory = [];
        this.avatarStates = {
            default: '🤖',
            cold: '🥶',
            family: '👨‍👩‍👧‍👦',
            travel: '✈️',
            excited: '🤩',
            thinking: '🤔'
        };
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.addWelcomeMessage();
    }

    setupEventListeners() {
        const sendBtn = document.getElementById('sendMessage');
        const input = document.getElementById('messageInput');
        
        sendBtn.addEventListener('click', () => this.sendMessage());
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') this.sendMessage();
        });
    }

    addWelcomeMessage() {
        this.addMessage('claude', 'Hi! I\'m Claude, your interactive pitch deck assistant! I know about your family trip presentation and can help answer questions about each slide. Try asking me about the current destination or what makes it special for families!');
    }

    onSlideChange(slideIndex, slideData) {
        this.currentSlide = slideIndex;
        this.presentationContent = slideData;
        
        // Update avatar based on slide content
        this.updateAvatar(slideData.raw);
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

    sendMessage() {
        const input = document.getElementById('messageInput');
        const message = input.value.trim();
        
        if (!message) return;
        
        this.addMessage('user', message);
        input.value = '';
        
        // Simulate Claude response (placeholder for now)
        setTimeout(() => {
            this.generateClaudeResponse(message);
        }, 500);
    }

    addMessage(sender, text) {
        const messagesContainer = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${sender}-message`;
        messageDiv.innerHTML = `<div class="message-content">${text}</div>`;
        
        messagesContainer.appendChild(messageDiv);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        
        this.chatHistory.push({ sender, text, timestamp: new Date() });
    }

    generateClaudeResponse(userMessage) {
        // This is a placeholder implementation
        // In a real implementation, this would integrate with Claude's API
        
        const message = userMessage.toLowerCase();
        let response = '';
        
        if (message.includes('slide') || message.includes('current')) {
            response = `We're currently on slide ${this.currentSlide + 1}. ${this.getSlideContext()}`;
        } else if (message.includes('family') || message.includes('kids')) {
            response = 'Family trips are amazing! This destination offers great activities for both adults and children. What specific aspects of family travel are you most interested in?';
            this.updateAvatar('family');
        } else if (message.includes('weather') || message.includes('cold') || message.includes('winter')) {
            response = 'Winter weather can be quite cold! ❄️ But that\'s part of the adventure. Make sure to pack warm clothes and think about cozy indoor activities too.';
            this.updateAvatar('cold');
        } else if (message.includes('cost') || message.includes('budget') || message.includes('expensive')) {
            response = 'Budget is definitely an important consideration for family trips. I can help you think through the costs and value proposition of different destinations.';
        } else {
            response = 'That\'s an interesting question! I\'m here to help discuss any aspect of the trip presentation. Feel free to ask about the destinations, logistics, or what makes each option special for families.';
        }
        
        this.addMessage('claude', response);
    }

    getSlideContext() {
        if (!this.presentationContent) {
            return 'I don\'t have information about this slide yet.';
        }
        
        const content = this.presentationContent.raw;
        if (content.includes('#')) {
            const title = content.match(/^#+ (.+)/m);
            return title ? `This slide is about "${title[1]}".` : 'Let me know what you\'d like to discuss about this slide!';
        }
        
        return 'Let me know what you\'d like to discuss about this slide!';
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.claudeChat = new ClaudeChat();
});