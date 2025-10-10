class PitchDeckPresentation {
    constructor() {
        this.slides = [];
        this.currentSlide = 0;
        this.init();
    }

    async init() {
        await this.loadMarkdownContent();
        this.setupEventListeners();
        this.renderCurrentSlide();
    }

    async loadMarkdownContent() {
        try {
            const response = await fetch('pitch-content.md');
            const markdownText = await response.text();
            
            // Split markdown into slides based on horizontal rules (---)
            const slideTexts = markdownText.split(/^---$/m);
            
            this.slides = slideTexts.map(slideText => ({
                content: marked.parse(slideText.trim()),
                raw: slideText.trim()
            }));
            
            this.updateSlideCounter();
        } catch (error) {
            // Fallback content if markdown file doesn't exist yet
            this.slides = [{
                content: marked.parse(`# Family Winter 2026 Trip

## Welcome to Our Pitch Deck!

This is a placeholder slide. Create \`pitch-content.md\` to add your real content.

### Sample Slide Structure:
- Use \`---\` to separate slides
- Write in markdown format
- Claude will be able to discuss each slide!`),
                raw: '# Family Winter 2026 Trip\n\n## Welcome to Our Pitch Deck!'
            }];
            this.updateSlideCounter();
        }
    }

    setupEventListeners() {
        document.getElementById('prevSlide').addEventListener('click', () => this.previousSlide());
        document.getElementById('nextSlide').addEventListener('click', () => this.nextSlide());
        
        // Keyboard navigation
        document.addEventListener('keydown', (e) => {
            if (e.key === 'ArrowLeft') this.previousSlide();
            if (e.key === 'ArrowRight') this.nextSlide();
        });
    }

    renderCurrentSlide() {
        const slideContent = document.getElementById('slideContent');
        slideContent.innerHTML = this.slides[this.currentSlide].content;
        
        // Notify chat system about slide change
        if (window.claudeChat) {
            window.claudeChat.onSlideChange(this.currentSlide, this.slides[this.currentSlide]);
        }
    }

    nextSlide() {
        if (this.currentSlide < this.slides.length - 1) {
            this.currentSlide++;
            this.renderCurrentSlide();
            this.updateSlideCounter();
        }
    }

    previousSlide() {
        if (this.currentSlide > 0) {
            this.currentSlide--;
            this.renderCurrentSlide();
            this.updateSlideCounter();
        }
    }

    updateSlideCounter() {
        document.getElementById('slideCounter').textContent = 
            `${this.currentSlide + 1} / ${this.slides.length}`;
    }

    getCurrentSlide() {
        return {
            index: this.currentSlide,
            slide: this.slides[this.currentSlide]
        };
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.presentation = new PitchDeckPresentation();
});