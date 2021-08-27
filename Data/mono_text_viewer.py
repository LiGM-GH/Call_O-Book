import pygame
from time import time


class TextViewer:
    def __init__(self, text, size, delay=0.07):
        self.text = text
        self.delay = delay
        self.animate_counter = 0
        self.local_time = None
        self.image = None
        try:
            self.font = pygame.font.Font('Data/Monospace.ttf', size)
        except FileNotFoundError:
            self.font = pygame.font.Font('Monospace.ttf', size)

    def animate_text(self):
        if self.local_time is None:
            self.local_time = time()
            self.animate_text()
        else:
            if time() >= self.local_time + self.delay and self.animate_counter <= len(self.text):
                self.local_time = time()
                text = self.text[:self.animate_counter]
                self.animate_counter += 1
                self.image = self.font.render(text, True, (0, 0, 0))
                return self.image
        return self.image


pygame.font.init()


if __name__ == '__main__':
    scr = pygame.display.set_mode((1000, 600))
    line = 'Something happened ...'
    tv = TextViewer(line, 35)
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit(0)
        scr.fill((255, 255, 255))
        image = tv.animate_text()
        if image:
            scr.blit(image, (0, 0))
        pygame.display.flip()
