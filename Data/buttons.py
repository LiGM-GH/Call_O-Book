import pygame


class Rect:
    def __init__(self, x, y, width, height):
        self.x = x
        self.y = y
        self.pos = (x, y)
        self.w = width
        self.h = height
        self.size = (width, height)

    def collidepoint(self, point):  # point <--> [x, y]
        if self.x <= point[0] <= self.x + self.w:
            if self.y <= point[1] <= self.y + self.h:
                return True
        return False


class InfoWindow:
    def __init__(self, info, size=40):
        self.info = info
        self.size = size
        self.window = self.make_window()

    def make_window(self):
        pygame.font.init()
        try:
            font = pygame.font.Font('Data/Monospace.ttf', self.size)
        except FileNotFoundError:
            font = pygame.font.Font('Monospace.ttf', self.size)
        self.info = self.info.split('\n')
        texts = [font.render(self.info[i], True, (255, 255, 255)) for i in range(len(self.info))]
        max_width = max([i.get_width() for i in texts])
        height = len(texts) * self.size
        image = pygame.Surface((max_width, height))
        image.fill((255, 0, 255))
        pygame.draw.rect(image, (0, 0, 0), [(0, 0), image.get_size()], 0, 7)
        for index, text in enumerate(texts):
            image.blit(text, (0, index * self.size))
        image.set_colorkey((255, 0, 255))
        return image


class Button:
    def __init__(self, text, text_size, pos, uid):
        self.info = InfoWindow(f'{uid}. ' + text)
        self.text = text
        self.uid = uid
        self.text_size = text_size
        _images = self.make_images(7)
        self.images = {'unseen': _images[0], 'seen': _images[1]}
        self.rect = Rect(pos[0], pos[1], self.images['seen'].get_width(), self.images['seen'].get_height())
        self.image = None
        self.view_info = False

    def make_images(self, length_of_button_string):
        pygame.font.init()
        try:
            font = pygame.font.Font('Data/Monospace.ttf', self.text_size)
        except FileNotFoundError:
            font = pygame.font.Font('Monospace.ttf', self.text_size)

        text = font.render(self.text[:length_of_button_string] + '...', True, (0, 0, 0))
        image_unseen = pygame.Surface(text.get_size())
        image_unseen.fill((255, 0, 255))
        pygame.draw.rect(image_unseen, (255, 255, 255), [(0, 0), image_unseen.get_size()], 0, 7)
        image_unseen.blit(text, (0, 0))
        image_unseen.set_colorkey((255, 0, 255))

        text = font.render(self.text[:length_of_button_string] + '...', True, (0, 0, 0))
        image_seen = pygame.Surface(text.get_size())
        image_seen.fill((255, 0, 255))
        pygame.draw.rect(image_seen, (230, 230, 230), [(0, 0), image_seen.get_size()], 0, 7)
        image_seen.blit(text, (0, 0))
        image_seen.set_colorkey((255, 0, 255))
        return image_unseen, image_seen

    def update(self, reaction='', mouse_pos=None):
        if reaction == '':
            self.image = self.images['unseen']
        elif reaction == 'mousemotion':
            if self.rect.collidepoint(mouse_pos):
                self.image = self.images['seen']
                self.view_info = True
            else:
                self.image = self.images['unseen']
                self.view_info = False
        elif reaction == 'mousebuttondown':
            if self.rect.collidepoint(mouse_pos):
                return self.uid
            return None


    def draw(self, screen):
        if self.image:
            screen.blit(self.image, self.rect.pos)


if __name__ == '__main__':
    pygame.init()
    scr = pygame.display.set_mode((1000, 600))
    btn1 = Button('Turn left and move around tree', 30, (10, 10), 1)
    btn2 = Button('Turn right and move\n around tree', 30, (210, 10), 2)
    btn3 = Button('Go back and move around tree', 30, (410, 10), 3)
    btn1.update()
    btn2.update()
    btn3.update()
    while True:
        answers = {'1': False, '2': False, '3': False}
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit(0)
            elif event.type == pygame.MOUSEMOTION:
                btn1.update('mousemotion', event.pos)
                btn2.update('mousemotion', event.pos)
                btn3.update('mousemotion', event.pos)
            elif event.type == pygame.MOUSEBUTTONDOWN:
                if event.button == 1:
                    if btn1.update('mousebuttondown', event.pos):
                        print(1)
                    elif btn2.update('mousebuttondown', event.pos):
                        print(2)
                    elif btn3.update('mousebuttondown', event.pos):
                        print(3)
        scr.fill((0, 0, 255))
        btn1.draw(scr)
        btn2.draw(scr)
        btn3.draw(scr)
        if btn1.view_info:
            scr.blit(btn1.info.window, (10, 100))
        elif btn2.view_info:
            scr.blit(btn2.info.window, (10, 100))
        elif btn3.view_info:
            scr.blit(btn3.info.window, (10, 100))
        pygame.display.flip()
