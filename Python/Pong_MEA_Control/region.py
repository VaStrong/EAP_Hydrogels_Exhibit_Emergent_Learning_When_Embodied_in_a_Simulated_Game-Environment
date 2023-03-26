import pygame
BLACK = (0, 0, 0)

class Region(pygame.sprite.Sprite):
    
    idTrack = 0
    
    def __init__(self, color, width, height):
        super().__init__()
        
        self.width = width
        self.height = height
        self.activeColor = color
        self.passiveColor = (max(0, min(255, color[0]+60)), max(0, min(255, color[1]+40)), color[2])
        
        self.image = pygame.Surface([width, height])
        
        pygame.draw.rect(self.image, self.passiveColor, [0, 0, width, height])
        pygame.draw.rect(self.image, BLACK, [0, 0, width, height], 4)
        
        self.rect = self.image.get_rect()
        
        self.active = False
        
        self.id = Region.idTrack
        Region.idTrack = Region.idTrack + 1
        
    def activate(self):
        if not self.active:
            self.active = True
            pygame.draw.rect(self.image, self.activeColor, [0, 0, self.width, self.height])
            pygame.draw.rect(self.image, BLACK, [0, 0, self.width, self.height], 4)
            
    def deactivate(self):
        if self.active:
            self.active = False
            pygame.draw.rect(self.image, self.passiveColor, [0, 0, self.width, self.height])
            pygame.draw.rect(self.image, BLACK, [0, 0, self.width, self.height], 4)