from Data.buttons import Button
from Data.mono_text_viewer import TextViewer
import pygame
from time import sleep


with open('Data/plot.txt') as f:
    plot = [i.strip() for i in f.read().split('\n')]
with open('Data/questions.txt') as f:
    questions = [i.strip() for i in f.read().split('\n')]
with open('Data/standard_answers.txt') as f:
    standard_answers = [i.strip() for i in f.read().split('\n')]

screen = pygame.display.set_mode((1336, 768))
clock = pygame.time.Clock()
FPS = 40

background_image = pygame.image.load('Data/cat_with_fish.jpg')
pygame.display.set_caption('call_O-Book')

act_number = '0'

run = True
while run:
    print(act_number)
    plot_block = []
    line = plot.index(f'Act {act_number}') + 1
    while plot[line] != '':
        plot_block.append(plot[line])
        line += 1
    print(*plot_block, sep='\n')
    write_plot = True
    lines = []
    for index, line in enumerate(plot_block):
        lines.append(TextViewer(line, 30))
    line = 0
    while write_plot:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                exit(0)
        screen.blit(background_image, (0, 0))
        image = lines[line].animate_text()
        if image:
            screen.blit(image, (200, 40 * line))
        if lines[line].animate_counter > len(lines[line].text):
            line += 1
        if line == len(lines):
            write_plot = False
        pygame.display.flip()
    if f'Ask {act_number}' in questions:
        questions_block = []
        answers = []
        line = questions.index(f'Ask {act_number}') + 1
        while questions[line] != '':
            if questions[line] == '-':
                answers.append([])
            elif questions[line] != '-':
                answers[-1].append(questions[line])
            questions_block.append(questions[line])
            line += 1
        print(*answers, sep='\n')
        choosing_answer = True
        buttons = []
        for index, i in enumerate(answers):
            buttons.append(Button('\n'.join(i), 30, (100 + 300 * index, 720), index + 1))
        for button in buttons:
            button.update()
        answer = None
        while choosing_answer:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    exit(0)
                elif event.type == pygame.MOUSEMOTION:
                    for button in buttons:
                        button.update('mousemotion', event.pos)
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 1:
                        for button in buttons:
                            answer = button.update('mousebuttondown', event.pos)
                            if answer:
                                choosing_answer = False
                                break
            screen.blit(background_image, (0, 0))
            for line in range(len(lines)):
                screen.blit(lines[line].animate_text(), (200, 40 * line))
            for button in buttons:
                button.draw(screen)
                if button.view_info:
                    screen.blit(button.info.window, (100, 710 - button.info.window.get_height()))
            pygame.display.flip()
        print(answer)
        act_number += f'.{answer}'
    if 'End' in plot_block or 'Win' in plot_block:
        run = False
        if 'End' in plot_block:
            print(standard_answers[0])
        elif 'Win' in plot_block:
            print(standard_answers[1])
sleep(2)
