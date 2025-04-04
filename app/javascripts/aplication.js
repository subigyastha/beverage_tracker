// app/javascript/application.js
document.addEventListener('DOMContentLoaded', () => {
    const menuToggle = document.getElementById('menu-toggle');
    const mobileMenu = document.getElementById('mobile-menu');
  
    if (menuToggle && mobileMenu) {
      menuToggle.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
      });
    }
  });

  


  document.addEventListener('DOMContentLoaded', () => {
    const cards = document.querySelectorAll('.beverage-card');
    cards.forEach(card => {
      card.addEventListener('click', (e) => {
        // Prevent clicking buttons from toggling
        if (e.target.tagName === 'A' || e.target.closest('a')) return;
        
        const id = card.getAttribute('data-id');
        const details = document.querySelector(`.beverage-details[data-id="${id}"]`);
        details.classList.toggle('hidden');
      });
    });
  });