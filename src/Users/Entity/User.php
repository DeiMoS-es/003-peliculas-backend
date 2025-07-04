<?php

namespace App\Users\Entity;

use App\Movies\Entity\Movie;
use App\Users\Repository\UserRepository;
use Doctrine\ORM\Mapping as ORM;
use Doctrine\Common\Collections\Collection;
use Doctrine\Common\Collections\ArrayCollection;
use Symfony\Component\Security\Core\User\PasswordAuthenticatedUserInterface;
use Symfony\Component\Security\Core\User\UserInterface;

#[ORM\Entity(repositoryClass: UserRepository::class)]
#[ORM\UniqueConstraint(name: 'UNIQ_IDENTIFIER_EMAIL', fields: ['email'])]

// TODO añadir campo de nombre, apellidos, foto, username y fecha de baja
class User implements UserInterface, PasswordAuthenticatedUserInterface
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 180)]
    private ?string $email = null;

    /**
     * @var list<string> The user roles
     */
    #[ORM\Column]
    private array $roles = [];

    /**
     * @var string The hashed password
     */
    #[ORM\Column]
    private ?string $password = null;

    #[ORM\Column(type: 'integer')]
    private int $status = 1; // activo por defecto

    #[ORM\Column(type: 'datetime_immutable')]
    private \DateTimeImmutable $createdAt;


    #[ORM\OneToMany(mappedBy: 'user', targetEntity: UserMovie::class, cascade: ['persist', 'remove'])]
    private Collection $userMovies;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    private string $nombre;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    private string $apellidos;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    private string $userName;

    #[ORM\Column(type: 'string', length: 255, nullable: true)]
    private ?string $imgUsuario;


    public function __construct()
    {
        $this->userMovies = new ArrayCollection();
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getImgUsuario(): ?string
    {
        return $this->imgUsuario;
    }

    public function setImgUsuario(?string $imgUsuario): static
    {
        $this->imgUsuario = $imgUsuario;
        return $this;
    }

    public function getNombre(): string
    {
        return $this->nombre;
    }
    public function setNombre(string $nombre): static
    {
        $this->nombre = $nombre;
        return $this;
    }

    public function getApellidos(): string
    {
        return $this->apellidos;
    }

    public function setApellidos(string $apellidos): static
    {
        $this->apellidos = $apellidos;
        return $this;
    }

    // public function getUserName(): string
    // {
    //     return $this->userName;
    // }

    public function setUserName(string $userName): static
    {
        $this->userName = $userName;
        return $this;
    }


    public function addUserMovie(UserMovie $userMovie): static
    {
        if (!$this->userMovies->contains($userMovie)) {
            $this->userMovies->add($userMovie);
        }
        return $this;
    }

    public function getUserMovies(): Collection
    {
        return $this->userMovies;
    }


    public function getStatus(): int
    {
        return $this->status;
    }

    public function setStatus(int $status): static
    {
        $this->status = $status;
        return $this;
    }

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }


    public function getId(): ?int
    {
        return $this->id;
    }

    public function getEmail(): ?string
    {
        return $this->email;
    }

    public function setEmail(string $email): static
    {
        $this->email = $email;

        return $this;
    }

    /**
     * A visual identifier that represents this user.
     *
     * @see UserInterface
     */
    public function getUserIdentifier(): string
    {
        return (string) $this->email;
    }

    /**
     * @see UserInterface
     */
    public function getRoles(): array
    {
        $roles = $this->roles;
        // guarantee every user at least has ROLE_USER
        $roles[] = 'ROLE_USER';

        return array_unique($roles);
    }

    /**
     * @param list<string> $roles
     */
    public function setRoles(array $roles): static
    {
        $this->roles = $roles;

        return $this;
    }

    /**
     * @see PasswordAuthenticatedUserInterface
     */
    public function getPassword(): ?string
    {
        return $this->password;
    }

    public function setPassword(string $password): static
    {
        $this->password = $password;

        return $this;
    }

    /**
     * @see UserInterface
     */
    public function eraseCredentials(): void
    {
        // If you store any temporary, sensitive data on the user, clear it here
        // $this->plainPassword = null;
    }
}
